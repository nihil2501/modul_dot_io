defmodule ModulDotIo.System.PatchMemory do
  use Ecto.Schema
  import Ecto.Changeset

  alias ModulDotIo.System.Patch

  schema "patch_memories" do
    belongs_to :patch, Patch
    field :links, :map
  end

  def changeset(patch_memory, params \\ %{}) do
    cast(patch_memory, params, [:links, :patch_id])
  end
end
