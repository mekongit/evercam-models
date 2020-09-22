use Mix.Config

config :evercam_models, ecto_repos: [Evercam.Repo, Evercam.SnapshotRepo, Evercam.AnalyticsRepo]

import_config "#{Mix.env()}.exs"
