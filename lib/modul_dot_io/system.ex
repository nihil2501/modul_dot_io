defmodule ModulDotIo.System do
  alias ModulDotIo.System.{Patch, PatchMemory}
  alias ModulDotIo.Repo

  def list_patches do
    Repo.all(Patch)
  end

  def create_patch(attrs \\ %{}) do
    %Patch{} |> Patch.changeset(attrs) |> Repo.insert()
  end

  def get_patch(id) do
    Repo.get(Patch, id)
  end

  def update_patch(patch, attrs) do
    patch |> Patch.changeset(attrs) |> Repo.update()
  end

  def delete_patch(id) do
    Repo.delete(%Patch{id: id})
  end

  def delete_all_patches do
    Repo.delete_all(Patch)
  end

  def get_or_create_patch_memory do
    with [patch] <- Repo.all(PatchMemory) do
      patch
    else
      _ ->
        attrs = %{patch_id: nil, links: %{}}
        {:ok, patch_memory} =
          %PatchMemory{}
          |> PatchMemory.changeset(attrs)
          |> Repo.insert()

        patch_memory
    end
  end

  def update_patch_memory(attrs \\ %{}) do
    Repo.update_all(PatchMemory, set: Map.to_list(attrs))
  end
end
