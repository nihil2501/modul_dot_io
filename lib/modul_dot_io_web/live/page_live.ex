defmodule ModulDotIoWeb.PageLive do
  use ModulDotIoWeb, :live_view

  alias Phoenix.LiveView.JS
  alias ModulDotIo.System
  alias ModulDotIo.System.{Io, LinkForming}

  @channel_ios (
    Map.new(97..122, fn i ->
      channel = String.to_atom(<<i>>)
      direction = if(Enum.member?(~w(q w e)a, channel), do: :output, else: :input)
      io = %Io{channel: channel, direction: direction}

      {channel, io}
    end)
  )

  def classes(channel, linked_channel) do
    case @channel_ios[channel] do
      %Io{direction: :output} ->
        ["channel-output", "channel-#{channel}"]
      %Io{direction: :input} ->
        if linked_channel do
          ["channel-input", "channel-#{linked_channel}"]
        else
          ["channel-input"]
        end
    end
  end

  def io(assigns) do
    ~H"""
    <div
      class={["key--letter" | classes(@channel, @linked_channel)]}
      phx-window-keydown={press_io()}
      phx-window-keyup={unpress_io()}
      phx-key={@channel}>
      <%= @channel %>
    </div>
    """
  end

  def press_io(js \\ %JS{}) do
    js
    |> JS.set_attribute({"data-pressed", "on"})
    |> JS.push("select_io")
  end

  def unpress_io(js \\ %JS{}) do
    js
    |> JS.push("deselect_io")
    |> JS.remove_attribute("data-pressed")
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, links: get_links())}
  end

  def handle_event("select_io", %{"repeat" => true}, socket), do: {:noreply, socket}
  def handle_event("select_io", %{"key" => channel, "repeat" => false}, socket) do
    LinkForming.select_io(@channel_ios[String.to_atom(channel)])
    {:noreply, assign(socket, links: get_links())}
  end

  def handle_event("deselect_io", %{"key" => channel}, socket) do
    LinkForming.deselect_io(@channel_ios[String.to_atom(channel)])
    {:noreply, socket}
  end

  defp get_links do
    @channel_ios
    |> Map.new(fn {k, _v} -> {k, nil} end)
    |> Map.merge(System.state())
  end
end
