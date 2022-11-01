defmodule ModulDotIo.Repo.Migrations.CreatePatchMemories do
  use Ecto.Migration

  def change do
    create table(:patch_memories) do
      add :patch_id, references("patches", on_delete: :nilify_all)
      add :links, :map, null: false
    end
  end
end
