defmodule ModulDotIo.System.Patch do
  use Ecto.Schema

  schema "patches" do
    field :name, :string
    field :links, :map
  end
end
