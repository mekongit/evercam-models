defmodule Evercam.Repo.Migrations.AddOverlaysTable do
  use Ecto.Migration

  def up do
    create table(:overlays) do
      add :project_id, references(:projects, on_delete: :nothing), null: false
      add :path, :string, null: false
      add :sw_bounds, :geography
      add :ne_bounds, :geography
    end
  end

  def down do
    drop table(:overlays)
  end
end
