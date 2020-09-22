defmodule Evercam.Repo.Migrations.AddStatusToCameras do
  use Ecto.Migration

  def change do
    # creating the database type
    execute("create type camera_status as enum ('online', 'offline', 'project_finished')")

    # creating a table with the column
    alter table(:cameras) do
      add :status, :camera_status, default: "online", null: false
    end
  end
end
