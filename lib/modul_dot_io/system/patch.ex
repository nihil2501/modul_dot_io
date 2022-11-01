defmodule ModulDotIo.System.Patch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "patches" do
    field :name, :string
    field :links, :map
  end

  def changeset(patch, attrs) do
    patch
    |> cast(attrs, [:name, :links])
    |> validate_required([:name, :links])
  end
end
