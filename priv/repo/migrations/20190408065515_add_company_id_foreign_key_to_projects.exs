defmodule Evercam.Repo.Migrations.AddCompanyIdForeignKeyToProjects do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :company_id, references(:companies, on_delete: :nothing)
    end
  end
end
