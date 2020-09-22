defmodule Evercam.Repo.Migrations.AddSimForeignKeyToMessage do
  use Ecto.Migration

  def change do
    alter table(:sms_messages) do
      add :sim_id, references(:sims, on_delete: :nothing)
    end
  end
end
