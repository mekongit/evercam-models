defmodule Evercam.Repo.Migrations.AddPersonaFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :persona, :text
    end
  end
end
