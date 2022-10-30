defmodule ModulDotIoWeb.PageLive do
  use ModulDotIoWeb, :live_view

  alias ModulDotIoWeb.LinkFormingComponent
  alias ModulDotIo.System
  alias ModulDotIo.System.Links

  def render(assigns) do
    ~H"""
    <.live_component
      module={LinkFormingComponent}
      id={LinkFormingComponent}
      links={@links}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, links: get_links())}
  end

  def handle_info({:link_formed, link}, socket) do
    Links.toggle_link(link)
    {:noreply, assign(socket, links: get_links())}
  end

  defp get_links do
    System.channel_ios()
    |> Map.new(fn {k, _v} -> {k, nil} end)
    |> Map.merge(System.state())
  end
end
