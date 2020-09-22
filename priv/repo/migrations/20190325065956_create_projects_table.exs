defmodule Evercam.Repo.Migrations.CreateProjectsTable do
  use Ecto.Migration

  def up do
    create table(:projects) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :exid, :string, null: false
      add :name, :string

      timestamps
    end
    create unique_index :projects, [:exid], name: :project_exid_unique_index
  end

  def down do
    drop table(:projects)
  end
end
