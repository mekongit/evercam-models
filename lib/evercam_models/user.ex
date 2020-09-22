defmodule User do
  use Evercam.Schema

  @email_regex ~r/^(?!.*\.{2})[a-zA-Z0-9!.#$%&'*+"\/=?^_`{|}~-]+@[a-zA-Z\d\-]+(\.[a-zA-Z]+)*\.[a-zA-Z]+\z/
  @name_regex ~r/^[\p{Xwd}\s,.']+$/
  @telephone_regex ~r/^\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$/

  @required_fields [:password, :firstname, :lastname, :email]
  @optional_fields [:linkedin_url, :twitter_url, :username, :telegram_username, :telephone, :referral_url, :api_id, :api_key, :reset_token, :token_expires_at, :payment_method, :company_id, :country_id, :confirmed_at, :updated_at, :last_login_at, :created_at, :is_admin, :persona, :sign_in_count, :last_sign_in_ip, :current_sign_in_at]

  schema "users" do
    belongs_to :country, Country, foreign_key: :country_id
    belongs_to :companies, Company, foreign_key: :company_id
    has_many :cameras, Camera, foreign_key: :owner_id
    has_many :camera_shares, CameraShare
    has_one :access_tokens, AccessToken
    has_many :oauth2_tokens, Oauth2Token
    has_many :sims, Sim
    has_many :messages, Message
    has_many :batteries, Battery

    field :username, :string
    field :telegram_username, :string
    field :telephone, :string
    field :referral_url, :string
    field :password, :string
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :api_id, :string
    field :api_key, :string
    field :reset_token, :string
    field :token_expires_at, :utc_datetime_usec
    field :stripe_customer_id, :string
    field :confirmed_at, :utc_datetime_usec
    field :last_login_at, :utc_datetime_usec
    field :current_sign_in_at, :utc_datetime_usec
    field :payment_method, :integer
    field :sign_in_count, :integer
    field :is_admin, :boolean
    field :last_sign_in_ip, InetType
    field :linkedin_url, :string
    field :twitter_url, :string
    field :persona, :string
    timestamps(inserted_at: :created_at, type: :utc_datetime_usec, default: Calendar.DateTime.now_utc)
  end

  def all do
    User
    |> Repo.all
  end

  def invalidate_auth(api_id, api_key) do
    ConCache.delete(:users, "#{api_id}_#{api_key}")
  end
  def invalidate_auth(token) do
    ConCache.delete(:users, "AUTH_#{token}")
  end

  def invalidate_share_users(%User{} = user) do
    CameraShare
    |> where([cs], cs.user_id == ^user.id or cs.sharer_id == ^user.id)
    |> preload(:camera)
    |> preload([camera: :owner])
    |> Repo.all
    |> Enum.map(fn(cs) -> cs.camera.owner end)
    |> Enum.uniq
    |> Enum.each(fn(user) -> Camera.invalidate_user(user) end)
  end

  def get_by_api_keys("", ""), do: nil
  def get_by_api_keys(nil, _api_key), do: nil
  def get_by_api_keys(_api_id, nil), do: nil
  def get_by_api_keys(api_id, api_key) do
    ConCache.dirty_get_or_store(:users, "#{api_id}_#{api_key}", fn() ->
      by_api_keys(api_id, api_key)
    end)
  end

  defp handle_response(nil, _), do: nil
  defp handle_response({:ok, claims}, access_token), do: assign_current_user(claims, access_token, access_token.user.email == claims["user_id"])
  defp handle_response({:error, _}, _), do: nil
  defp handle_response(access_token, token), do: JwtAuthToken.verify_and_validate(token) |> handle_response(access_token)

  defp assign_current_user(_claims, access_token, true), do: access_token.user
  defp assign_current_user(claims, _access_token, false), do: User.by_username_or_email(claims["user_id"])

  def get_by_token(""), do: nil
  def get_by_token(token) do
    ConCache.dirty_get_or_store(:users, "AUTH_#{token}", fn() ->
      AccessToken.by_request_token(token) |> handle_response(token)
    end)
  end

  def by_username_or_email(login) when login in["", nil], do: nil
  def by_username_or_email(login) do
    login = String.downcase(login)
    User
    |> where([u], fragment("lower(?)", u.username) == ^login or fragment("lower(?)", u.email) == ^login)
    |> preload(:country)
    |> preload(:companies)
    |> Repo.one
  end

  def by_telegram_username(login) when login in["", nil], do: nil
  def by_telegram_username(login) do
    login = String.downcase(login)
    User
    |> where([u], fragment("lower(?)", u.telegram_username) == ^login)
    |> preload(:country)
    |> Repo.one
  end

  def by_telephone(login) when login in["", nil], do: nil
  def by_telephone(login) do
    login = String.downcase(login)
    User
    |> where([u], fragment("lower(?)", u.telephone) == ^login)
    |> preload(:country)
    |> Repo.one
  end

  def by_username(username) do
    User
    |> where(username: ^String.downcase(username))
    |> preload(:country)
    |> preload(:companies)
    |> Repo.one
  end

  def by_api_keys(api_id, api_key) do
    User
    |> where(api_id: ^api_id)
    |> where(api_key: ^api_key)
    # |> preload(:access_tokens)
    |> Repo.one
  end

  def by_email_domain(domain) do
    User
    |> where([u], like(u.email, ^"%@#{domain}"))
    |> Repo.all
  end

  def link_company(user, company_id) do
    User.update_changeset(user, %{company_id: company_id})
    |> Repo.update
  end

  def with_access_to(camera_full) do
    User
    |> join(:inner, [u], cs in CameraShare)
    |> where([_, cs], cs.camera_id == ^camera_full.id)
    |> where([u, cs], u.id == cs.user_id)
    |> Repo.all
    |> Enum.concat([camera_full.owner])
  end

  def get_country_attr(user, attr) do
    case user.country do
      nil -> ""
      country -> Map.get(country, attr)
    end
  end

  def get_fullname(nil), do: ""
  def get_fullname(user) do
    "#{user.firstname} #{user.lastname}"
  end

  def get_user_from_token(token) do
    token = AccessToken.by_request_token(token)
    cond do
      nil == token -> nil
      user = token.user -> user
      grantor = token.grantor -> grantor
      true -> token
    end
  end

  def delete_by_id(user_id) do
    User
    |> where(id: ^user_id)
    |> Repo.delete_all
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, hash_password(password))
      _ ->
        changeset
    end
  end

  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password, [12, true])
  end

  def has_username(changeset) do
    case get_field(changeset, :username) do
      username when username in [nil, ""] -> put_change(changeset, :username, get_field(changeset, :email))
      _ ->
        changeset
        |> put_change(:username, get_field(changeset, :email))
        |> update_change(:username, &String.downcase/1)
    end
  end

  def update_user(user, params) do
    User.update_changeset(user, params)
    |> Repo.update
  end

  def update_changeset(user, params \\ :invalid) do
    user |> cast(params, @required_fields ++ @optional_fields)
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> has_username
    |> unique_constraint(:email, [name: :user_email_unique_index, message: "Email has already been taken."])
    |> unique_constraint(:username, [name: :user_username_unique_index, message: "Username has already been taken."])
    |> validate_format(:firstname, @name_regex)
    |> validate_format(:lastname, @name_regex)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email_regex, [message: "Email format isn't valid!"])
    |> validate_format(:telephone, @telephone_regex, [message: "Telephone format isn't valid!"])
    |> validate_length(:password, [min: 6, message: "Password should be at least 6 character(s)."])
    |> encrypt_password
    |> update_change(:firstname, &String.trim/1)
    |> update_change(:lastname, &String.trim/1)
    |> validate_length(:firstname, [min: 2, message: "Firstname should be at least 2 character(s)."])
    |> validate_length(:lastname, [min: 2, message: "Lastname should be at least 2 character(s)."])
  end
end
