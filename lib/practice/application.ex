defmodule Practice.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PracticeWeb.Telemetry,
      # Start the Ecto repository
      Practice.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Practice.PubSub},
      # Start Finch
      {Finch, name: Practice.Finch},
      # Start the Endpoint (http/https)
      PracticeWeb.Endpoint
      # Start a worker by calling: Practice.Worker.start_link(arg)
      # {Practice.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Practice.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PracticeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
