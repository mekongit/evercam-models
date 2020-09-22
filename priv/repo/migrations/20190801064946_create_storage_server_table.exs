defmodule Evercam.Repo.Migrations.CreateStorageServerTable do
  use Ecto.Migration

  def up do
    create table(:storage_servers) do
      add :server_name, :string, null: false
      add :start_datetime, :utc_datetime, null: false
      add :stop_datetime, :utc_datetime, null: false
      add :ip, :string, null: false
      add :port, :int, null: false
      add :weed_type, :string, null: false
      add :weed_attribute, :string, null: false
      add :weed_files, :string, null: false
      add :weed_name, :string, null: false
      add :weed_mode, :string, null: false, default: "R"
      add :app_list, :string, null: false, default: "recordings,archives"

      timestamps
    end
  end

  def down do
    drop table(:storage_servers)
  end
end
