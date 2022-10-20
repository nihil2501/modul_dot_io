defmodule ModulDotIo.Repo do
  use Ecto.Repo,
    otp_app: :modul_dot_io,
    adapter: Ecto.Adapters.Postgres
end
