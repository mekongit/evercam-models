defmodule Evercam.Repo.Migrations.AddPlaybackUrlFieldToVendor do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :playback_url, :string
    end
  end
end
