defmodule ModulDotIo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ModulDotIo.Repo,
      # Start the Telemetry supervisor
      ModulDotIoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ModulDotIo.PubSub},
      # Start the Endpoint (http/https)
      ModulDotIoWeb.Endpoint
      # Start a worker by calling: ModulDotIo.Worker.start_link(arg)
      # {ModulDotIo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ModulDotIo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ModulDotIoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
