defmodule ModulDotIoWeb.PatchComponent do
  use ModulDotIoWeb, :live_component

  alias ModulDotIo.System

  def mount(socket) do
    patches = get_patches()
    patch_memory = System.get_or_create_patch_memory()
    patch_id = patch_memory.patch_id
    links = deserialize_links(patch_memory.links)
    patch_links = if patch_id, do: get_patch_links(patch_id), else: %{}

    assigns = %{
      patches: patches,
      patch_id: patch_id,
      patch_links: patch_links,
      links: links
    }

    {:ok, assign(socket, assigns)}
  end

  def update(assigns, socket) do
    assigns = Map.update!(assigns, :links, &serialize_links(&1))
    socket = assign(socket, assigns)

    socket.assigns
      |> Map.take([:patch_id, :links])
      |> System.update_patch_memory()

    {:ok, socket}
  end

  def handle_event("load_patch", %{"patch_form" => %{"patch_id" => ""}}, socket) do
    {id, links} = {nil, %{}}
    send(self(), {:links_replaced, links})

    assigns = %{patch_id: id, patch_links: links}
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("load_patch", %{"patch_form" => %{"patch_id" => id}}, socket) do
    id = String.to_integer(id)
    links = get_patch_links(id)
    send(self(), {:links_replaced, links})

    assigns = %{patch_id: id, patch_links: links}
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("update_patch", _params, socket) do
    id = socket.assigns.patch_id
    links = socket.assigns.links |> serialize_links()
    id |> System.get_patch() |> System.update_patch(%{links: links})

    assigns = %{patch_links: links}
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("reload_patch", _params, socket) do
    links = socket.assigns.patch_links
    send(self(), {:links_replaced, links})

    {:noreply, socket}
  end

  def handle_event("create_patch", %{"new_patch_form" => %{"name" => name}}, socket) do
    links = socket.assigns.links |> serialize_links()
    {:ok, patch} = System.create_patch(%{name: name, links: links})
    patches = get_patches()

    send(self(), :done_saving_patch)

    assigns = %{patch_id: patch.id, patch_links: links, patches: patches}
    assigns |> Map.take([:patch_id, :links]) |> System.update_patch_memory()
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("delete_patch", _params, socket) do
    socket.assigns.patch_id |> System.delete_patch()
    patches = get_patches()
    links = %{}

    send(self(), {:links_replaced, links})

    assigns = %{patches: patches, patch_id: nil, patch_links: links}
    {:noreply, assign(socket, assigns)}
  end

  defp get_patches do
    System.list_patches() |> Enum.map(&({&1.name, &1.id}))
  end

  def get_patch_links(id) do
    System.get_patch(id).links |> deserialize_links()
  end

  defp serialize_links(links) do
    for {k, v} <- links, v != nil, into: %{}, do: {k, v}
  end

  defp deserialize_links(links) do
    Map.new(links, &({
      String.to_atom(elem(&1, 0)),
      String.to_atom(elem(&1, 1))
    }))
  end
end
