defmodule Evercam.Repo.Migrations.AddAuthTypeField do
  use Ecto.Migration

  def change do
    alter table(:vendor_models) do
      add :auth_type, :string, default: "basic", null: false
      remove :config
    end
  end
end
