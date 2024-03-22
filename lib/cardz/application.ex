defmodule Cardz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CardzWeb.Telemetry,
      Cardz.Repo,
      {DNSCluster, query: Application.get_env(:cardz, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cardz.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cardz.Finch},
      # Start a worker by calling: Cardz.Worker.start_link(arg)
      # {Cardz.Worker, arg},
      # Start to serve requests, typically the last entry
      CardzWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cardz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CardzWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
