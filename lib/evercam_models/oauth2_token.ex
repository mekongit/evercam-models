defmodule Oauth2Token do
  use Evercam.Schema

  alias __MODULE__
  @derive {Jason.Encoder, only: [:id, :provider, :login, :created_at, :expires_at]}

  @required_fields [
    :user_id,
    :provider,
    :login,
    :access_token,
    :refresh_token,
    :created_at,
    :expires_at
  ]
  @optional_fields [:owner_id]

  @unique_fields [:user_id, :provider, :login]

  schema "oauth2_tokens" do
    belongs_to(:user, User, foreign_key: :user_id)

    field(:provider, :string, null: false)
    field(:login, :string, null: false)
    field(:owner_id, :string)
    field(:access_token, :string, null: false)
    field(:refresh_token, :string, null: false)
    field(:created_at, :utc_datetime, null: false)
    field(:expires_at, :utc_datetime, null: false)
  end

  def changeset(schema, params \\ []) do
    schema
    |> cast(params, @required_fields ++ @optional_fields)
    |> foreign_key_constraint(:user_id)
  end

  def by_user_id(user_id) do
    Oauth2Token
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def by_id(user_id, token_id) do
    Oauth2Token
    |> where(user_id: ^user_id, id: ^token_id)
    |> Repo.one()
  end

  def insert!(params \\ []) do
    %Oauth2Token{}
    |> changeset(params)
    |> Repo.insert!(conflict_target: @unique_fields, on_conflict: :replace_all_except_primary_key)
  end
end
