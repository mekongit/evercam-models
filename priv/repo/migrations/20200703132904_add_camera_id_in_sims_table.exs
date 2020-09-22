defmodule Evercam.Repo.Migrations.AddCameraIdInSimsTable do
  use Ecto.Migration

  def change do
    alter table(:sims) do
      add :camera_id, references(:cameras, on_delete: :nothing)
    end
  end
end
