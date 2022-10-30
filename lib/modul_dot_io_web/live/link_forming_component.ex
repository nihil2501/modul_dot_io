defmodule ModulDotIoWeb.LinkFormingComponent do
  use ModulDotIoWeb, :live_component

  import ModulDotIoWeb.IoComponent

  alias ModulDotIo.System.LinkForming
  alias ModulDotIo.System

  # Client also stops propagation of key repeats, so this guard is redundant.
  def handle_event("select_io", %{"repeat" => true}, socket), do: {:noreply, socket}
  def handle_event("select_io", %{"key" => channel, "repeat" => false}, socket) do
    io = get_io(channel)
    with {:ok, link} <- LinkForming.select_io(io) do
      send(self(), {:link_formed, link})
    end

    {:noreply, socket}
  end

  def handle_event("deselect_io", %{"key" => channel}, socket) do
    channel |> get_io() |> LinkForming.deselect_io()
    {:noreply, socket}
  end

  defp get_io(channel) do
    channel = String.to_atom(channel)
    System.channel_ios()[channel]
  end
end
