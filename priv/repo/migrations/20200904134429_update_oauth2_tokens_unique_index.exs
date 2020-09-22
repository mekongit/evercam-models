defmodule Evercam.Repo.Migrations.UpadateOauth2TokensUniqueIndex do
  use Ecto.Migration

  def up do
    drop unique_index(:oauth2_token, "oauth2_tokens_provider_login_key")
    create unique_index(:oauth2_tokens, [:user_id, :provider, :login], name: :oauth2_tokens_provider_login_key)
  end

  def down do
    drop unique_index(:oauth2_token, "oauth2_tokens_provider_login_key")
    create unique_index(:oauth2_tokens, [:provider, :login], name: :oauth2_tokens_provider_login_key)
  end
end
