defmodule EvercamModels.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: EvercamModels.Worker.start_link(arg)
      # {EvercamModels.Worker, arg}
      {Evercam.Repo, []},
      {Evercam.SnapshotRepo, []},
      {Evercam.AnalyticsRepo, []}
      # {ConCache,[ttl_check_interval: :timer.seconds(0.1), global_ttl: :timer.seconds(2.5), name: :cache]}
    ]

    opts = [strategy: :one_for_one, name: EvercamModels.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
