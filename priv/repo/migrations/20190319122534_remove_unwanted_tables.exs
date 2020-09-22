defmodule Evercam.Repo.Migrations.RemoveUnwantedTables do
  use Ecto.Migration

  def change do
    drop table(:users_old)
    drop table(:webhooks)
    drop table(:licences)
    drop table(:camera_endpoints)
    drop table(:billing)
    drop table(:add_ons)
    drop table(:motion_detections)
    drop table(:apps)
    drop table(:clients)
    drop table(:ar_internal_metadata)
  end
end
