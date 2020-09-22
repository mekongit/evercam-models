defmodule Evercam.Repo.Migrations.AddUserIdAndRef do
  use Ecto.Migration

  def change do
    alter table(:access_rights) do
      modify :token_id, :integer, null: true
      
      add :user_id, references(:users, type: :integer, on_delete: :nothing)
    end
  end
end
