defmodule ModulDotIo.System do
  alias ModulDotIo.System.Io

  @channel_ios (
    Map.new(97..122, fn i ->
      channel = String.to_atom(<<i>>)
      output? = Enum.member?(~w(q w e)a, channel)
      direction = if(output?, do: :output, else: :input)
      io = %Io{channel: channel, direction: direction}

      {channel, io}
    end)
  )

  # The information about what direction an Io is set to is only possessed by
  # the Io's. Io's will include it when informing the modul during link-forming,
  # and they also use it locally to determine their own appearance. This should
  # maybe be moved to a different file.
  def channel_ios, do: @channel_ios

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
