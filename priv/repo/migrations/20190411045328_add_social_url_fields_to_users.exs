defmodule Evercam.Repo.Migrations.AddSocialUrlFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :linkedin_url, :text
      add :twitter_url, :text
    end
  end
end
