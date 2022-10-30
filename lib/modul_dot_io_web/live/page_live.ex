defmodule ModulDotIoWeb.PageLive do
  use ModulDotIoWeb, :live_view

  alias ModulDotIoWeb.LinkFormingComponent
  alias ModulDotIo.System.Links
  import ModulDotIo.System, only: [channel_ios: 0]

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
    Links.start()
    {:ok, links} = Links.get()
    links = coalesce_links(links)

    {:ok, assign(socket, links: links)}
  end

  def handle_info({:link_formed, link}, socket) do
    {:ok, links} = Links.toggle_link(link)
    links = coalesce_links(links)

    {:noreply, assign(socket, links: links)}
  end

  defp coalesce_links(links) do
    channel_ios()
    |> Map.new(fn {k, _v} -> {k, nil} end)
    |> Map.merge(links)
  end
end
