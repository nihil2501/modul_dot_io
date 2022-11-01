defmodule ModulDotIoWeb.LinkComponent do
  use ModulDotIoWeb, :live_component

  import ModulDotIoWeb.IoComponent
  import ModulDotIo.System, only: [channel_ios: 0]

  alias ModulDotIo.System.{Io, Link}

  def mount(socket) do
    {:ok, assign(socket, output_ios: %MapSet{})}
  end

  # Client also stops propagation of key repeats, so this guard is redundant.
  def handle_event("select_io", %{"repeat" => true}, socket), do: {:noreply, socket}
  def handle_event("select_io", %{"key" => channel, "repeat" => false}, socket) do
    output_ios = select_io(socket.assigns.output_ios, get_io(channel))
    {:noreply, assign(socket, output_ios: output_ios)}
  end

  def handle_event("deselect_io", %{"key" => channel}, socket) do
    output_ios = deselect_io(socket.assigns.output_ios, get_io(channel))
    {:noreply, assign(socket, output_ios: output_ios)}
  end

  defp select_io(output_ios, %Io{direction: :output} = io) do
    MapSet.put(output_ios, io)
  end

  defp select_io(output_ios, %Io{direction: :input} = input_io) do
    with [%Io{} = output_io] <- MapSet.to_list(output_ios) do
      link = %Link{input_io: input_io, output_io: output_io}
      send(self(), {:link_updated, link})
    end

    output_ios
  end

  defp deselect_io(output_ios, %Io{direction: :output} = io) do
    MapSet.delete(output_ios, io)
  end

  defp deselect_io(output_ios, %Io{direction: :input}) do
    output_ios
  end

  defp get_io(channel) do
    channel = String.to_atom(channel)
    channel_ios()[channel]
  end
end
