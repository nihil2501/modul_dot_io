defmodule ModulDotIo.Repo.Migrations.CreatePatches do
  use Ecto.Migration

  def change do
    create table(:patches) do
      add :name, :string, null: false
      add :links, :map, null: false
    end
  end
end
