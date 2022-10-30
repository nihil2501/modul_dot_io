defmodule ModulDotIoWeb.PageLive do
  use ModulDotIoWeb, :live_view
  import ModulDotIoWeb.IoComponent

  alias ModulDotIo.System.LinkForming
  alias ModulDotIo.System

  # Client also stops propagation of key repeats, so this guard is redundant.
  def handle_event("select_io", %{"repeat" => true}, socket), do: {:noreply, socket}
  def handle_event("select_io", %{"key" => channel, "repeat" => false}, socket) do
    channel |> get_io() |> LinkForming.select_io()
    {:noreply, assign(socket, links: get_links())}
  end

  def handle_event("deselect_io", %{"key" => channel}, socket) do
    channel |> get_io() |> LinkForming.deselect_io()
    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, links: get_links())}
  end

  defp get_links do
    System.channel_ios()
    |> Map.new(fn {k, _v} -> {k, nil} end)
    |> Map.merge(System.state())
  end

  defp get_io(channel) do
    channel = String.to_atom(channel)
    System.channel_ios()[channel]
  end
end
