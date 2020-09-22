defmodule Evercam.Repo.Migrations.AddTelephoneToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :telephone, :string
    end
  end
end
