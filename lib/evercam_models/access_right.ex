defmodule AccessRight do
  use Evercam.Schema

  @required_fields [:right, :status]
  @optional_fields [:token_id, :user_id, :camera_id, :grantor_id, :account_id, :scope, :updated_at, :created_at]
  @camera_rights ["delete", "edit", "list", "snapshot", "share", "view", "grant~delete",
                  "grant~edit", "grant~list", "grant~snapshot", "grant~share", "grant~view"]
  @status %{active: 1, deleted: -1}

  schema "access_rights" do
    belongs_to :access_token, AccessToken, foreign_key: :token_id
    belongs_to :camera, Camera, foreign_key: :camera_id
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :grantor, User, foreign_key: :grantor_id
    belongs_to :account, User, foreign_key: :account_id

    field :right, :string
    field :status, :integer
    field :scope, :string
    timestamps(inserted_at: :created_at, type: :utc_datetime, default: Calendar.DateTime.now_utc)
  end

  def all do
    AccessRight
    |> where(status: 1)
    |> preload(:access_token)
    |> preload([access_token: :user])
    |> Repo.all
  end

  def allows?(requester, resource, right, scope) do
    access_rights =
      AccessRight
      |> where([ar], ar.user_id == ^requester.id)
      |> where(account_id: ^resource.id)
      |> where(status: 1)
      |> where(right: ^right)
      |> where(scope: ^scope)
      |> Repo.all

    case access_rights do
      nil -> false
      [] -> false
      _ -> true
    end
  end

  def camera_rights, do: @camera_rights

  def valid_right_name?(name) when name in [nil, ""], do: false
  def valid_right_name?(name) do
    Enum.member?(@camera_rights, name)
  end

  def grant(user, camera, rights) do
    saved_rights = recorded_rights(user, camera)
    rights
    |> Enum.uniq
    |> Enum.reject(fn(right) -> Enum.member?(saved_rights, right) end)
    |> Enum.each(fn(right) ->
      unless Camera.is_owner?(user, camera) do
        right_params = %{user_id: user.id, camera_id: camera.id, right: right, status: @status.active}
        %AccessRight{}
        |> changeset(right_params)
        |> Repo.insert
      end
    end)
  end

  def recorded_rights(user, camera) do
    AccessRight
    |> where(user_id: ^user.id)
    |> where(camera_id: ^camera.id)
    |> where(status: ^@status.active)
    |> Repo.all
    |> Enum.map(fn(ar) -> ar.right end)
    |> Enum.uniq
  end

  def revoke(user, camera, rights) do
    if !Camera.is_owner?(user, camera) do
      AccessRight
      |> where(user_id: ^user.id)
      |> where(camera_id: ^camera.id)
      |> where(status: ^@status.active)
      |> where([r], r.right in ^rights)
      |> Repo.update_all(set: [status: @status.deleted])
    end
  end

  def delete_by_user(user_id) do
    AccessRight
    |> where(user_id: ^user_id)
    |> Repo.delete_all
  end

  def delete_by_camera(camera_id) do
    AccessRight
    |> where(camera_id: ^camera_id)
    |> Repo.delete_all
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
