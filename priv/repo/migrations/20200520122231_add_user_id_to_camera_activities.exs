defmodule Evercam.Repo.Migrations.AddUserIdToCameraActivities do
  use Ecto.Migration

  def change do
    alter table(:camera_activities) do
      add :user_id, :integer, null: true
    end
  end
end
