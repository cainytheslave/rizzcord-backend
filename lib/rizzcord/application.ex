defmodule Rizzcord.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RizzcordWeb.Telemetry,
      Rizzcord.Repo,
      {DNSCluster, query: Application.get_env(:rizzcord, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Rizzcord.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Rizzcord.Finch},
      # Start a worker by calling: Rizzcord.Worker.start_link(arg)
      # {Rizzcord.Worker, arg},
      # Start to serve requests, typically the last entry
      RizzcordWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rizzcord.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RizzcordWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
