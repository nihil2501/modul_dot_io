defmodule ModulDotIo.System.Modul do
  use Ecto.Schema

  alias ModulDotIo.System.Patch

  schema "moduls" do
    belongs_to :patch, Patch
    field :links, :map
  end
end
