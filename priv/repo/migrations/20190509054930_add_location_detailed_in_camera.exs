defmodule Evercam.Repo.Migrations.AddLocationDetailedInCamera do
  use Ecto.Migration

  def change do
    alter table(:cameras) do
      add :location_detailed, :json
    end
  end
end
