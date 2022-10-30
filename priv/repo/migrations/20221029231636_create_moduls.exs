defmodule ModulDotIo.Repo.Migrations.CreateModuls do
  use Ecto.Migration

  def change do
    create table(:moduls) do
      add :patch_id, references("patches")
      add :links, :map, null: false
    end
  end
end
