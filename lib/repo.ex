defmodule Evercam.Repo do
  use Ecto.Repo,
    otp_app: :evercam_models,
    adapter: Ecto.Adapters.Postgres
end

defmodule Evercam.SnapshotRepo do
  use Ecto.Repo,
    otp_app: :evercam_models,
    adapter: Ecto.Adapters.Postgres
end

defmodule Evercam.AnalyticsRepo do
  use Ecto.Repo,
    otp_app: :evercam_models,
    adapter: Ecto.Adapters.Postgres
end
