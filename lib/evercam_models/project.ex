defmodule Project do
  use Evercam.Schema

  @required_fields [:name, :user_id]
  @optional_fields [ :exid, :updated_at, :inserted_at]

  schema "projects" do
    belongs_to :user, User, foreign_key: :user_id
    has_many :cameras, Camera
    has_many :overlays, Overlay

    field :name, :string
    field :exid, :string
    timestamps(type: :utc_datetime_usec, default: Calendar.DateTime.now_utc)
  end

  def by_user(user_id) do
    Project
    |> where(user_id: ^user_id)
    |> preload(:user)
    |> preload(:cameras)
    |> preload(:overlays)
    |> Repo.all
  end

  def by_exid(exid) do
    Project
    |> where(exid: ^exid)
    |> preload(:user)
    |> preload(:cameras)
    |> preload(:overlays)
    |> Repo.one
  end

  def delete_by_exid(exid) do
    Project
    |> where(exid: ^exid)
    |> Repo.delete_all
  end

  defp validate_exid(changeset) do
    case get_field(changeset, :exid) do
      nil -> auto_generate_camera_id(changeset)
      _exid -> changeset |> update_change(:exid, &String.downcase/1)
    end
  end

  defp auto_generate_camera_id(changeset) do
    case get_field(changeset, :name) do
      nil ->
        changeset
      subject ->
        project_id =
          subject
          |> Util.slugify
          |> String.replace(" ", "")
          |> String.replace("-", "")
          |> String.downcase
          |> String.slice(0..4)
        put_change(changeset, :exid, "#{project_id}-#{Enum.take_random(?a..?z, 5)}")
    end
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_exid
  end
end
