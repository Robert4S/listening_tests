defmodule ExListening.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExListeningWeb.Telemetry,
      ExListening.Repo,
      {DNSCluster, query: Application.get_env(:ex_listening, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExListening.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ExListening.Finch},
      # Start a worker by calling: ExListening.Worker.start_link(arg)
      # {ExListening.Worker, arg},
      # Start to serve requests, typically the last entry
      ExListeningWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExListening.Supervisor]
    Process.flag(:trap_exit, true)

    :ets.new(:pids_table, [:named_table, :public, :set])
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExListeningWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
