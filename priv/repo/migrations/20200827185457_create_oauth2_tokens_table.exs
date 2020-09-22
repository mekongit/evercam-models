defmodule Evercam.Repo.Migrations.CreateOauth2TokensTable do
  use Ecto.Migration

  def change do
    create table(:oauth2_tokens) do
      add(:user_id, references(:users))
      add(:provider, :string, null: false)
      add(:login, :string, null: false)
      add(:owner_id, :string)
      add(:access_token, :text, null: false)
      add(:refresh_token, :text, null: false)
      add(:created_at, :utc_datetime, null: false)
      add(:expires_at, :utc_datetime, null: false)
    end

    create(
      unique_index(:oauth2_tokens, [:provider, :login], name: :oauth2_tokens_provider_login_key)
    )
  end
end
