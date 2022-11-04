defmodule ModulDotIoWeb.PageLive do
  use ModulDotIoWeb, :live_view

  alias ModulDotIoWeb.{LinkComponent, PatchComponent}
  import ChannelIos, only: [channel_ios: 0]

  def render(assigns) do
    ~H"""
    <.live_component
      module={PatchComponent}
      id={PatchComponent}
      linking_enabled={@linking_enabled}
      links={@links}
    />
    <%= if @links do %>
      <.live_component
        module={LinkComponent}
        id={LinkComponent}
        linking_enabled={@linking_enabled}
        links={@links}
      />
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    assigns = %{links: nil, linking_enabled: true}
    {:ok, assign(socket, assigns)}
  end

  def handle_event("saving_patch", _params, socket) do
    {:noreply, assign(socket, linking_enabled: false)}
  end

  def handle_event("done_saving_patch", _params, socket) do
    {:noreply, assign(socket, linking_enabled: true)}
  end

  def handle_info(:done_saving_patch, socket) do
    {:noreply, assign(socket, linking_enabled: true)}
  end

  def handle_info({:link_updated, link}, socket) do
    links = socket.assigns.links |> update_link(link) |> coalesce_links()
    {:noreply, assign(socket, links: links)}
  end

  def handle_info({:links_replaced, links}, socket) do
    links = coalesce_links(links)
    {:noreply, assign(socket, links: links)}
  end

  defp update_link(links, link) do
    # toggle link
    output_channel_update =
      fn channel ->
        next_channel = link.output_io.channel
        if next_channel != channel do
          {channel, next_channel}
        else
          :pop
        end
      end

    input_channel = link.input_io.channel
    {_, next_links} =
      Map.get_and_update(
        links,
        input_channel,
        output_channel_update
      )

    next_links
  end

  defp coalesce_links(links) do
    channel_ios()
    |> Map.new(fn {k, _v} -> {k, nil} end)
    |> Map.merge(links)
  end
end
