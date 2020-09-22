defmodule Evercam.Repo.Migrations.AddProjectIdForeignKey do
  use Ecto.Migration

  def change do
    alter table(:cameras) do
      add :project_id, references(:projects, on_delete: :nothing)
    end
  end
end
