defmodule ModulDotIoWeb.PatchLive do
  use ModulDotIoWeb, :live_view

  alias ModulDotIo.System
  alias ModulDotIo.System.{Io, LinkForming}

  @channel_ios (
    Map.new(97..122, fn i ->
      channel = <<i>>
      direction = if(rem(i, 5) == 0, do: :output, else: :input)
      io = %Io{channel: channel, direction: direction}

      {channel, io}
    end)
  )

  def classes(links, channel) do
    memo =
      case @channel_ios[channel] do
        %Io{direction: :output} ->
          ["channel-#{channel}", "channel-output"]
        %Io{direction: :input} ->
          if links[channel] do
            ["channel-#{links[channel]}", "channel-input"]
          else
            []
          end
      end

    Enum.join(["key--letter" | memo], " ")
  end

  def mount(_params, _session, socket) do
    links = System.state()
    {:ok, assign(socket, links: links)}
  end

  def handle_event("select_io", %{"repeat" => true}, socket), do: {:noreply, socket}
  def handle_event("select_io", %{"key" => channel, "repeat" => false}, socket) do
    LinkForming.select_io(@channel_ios[channel])
    links = System.state()
    {:noreply, assign(socket, links: links)}
  end

  def handle_event("deselect_io", %{"key" => channel}, socket) do
    LinkForming.deselect_io(@channel_ios[channel])
    {:noreply, socket}
  end
end
