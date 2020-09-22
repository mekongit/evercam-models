defmodule Evercam.Repo.Migrations.CreateCompaniesTable do
  use Ecto.Migration

  def up do
    create table(:companies) do
      add :exid, :string, null: false
      add :name, :string, null: false
      add :website, :string
      add :size, :integer, default: 0
      add :session_count, :integer, default: 0
      add :linkedin_url, :text

      timestamps()
    end
    create unique_index :companies, [:exid], name: :companies_exid_unique_index
  end

  def down do
    drop table(:companies)
  end
end
