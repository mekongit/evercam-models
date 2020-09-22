defmodule StorageServer do
  use Evercam.Schema

  @required_fields [:server_name, :ip, :port, :weed_type, :weed_attribute, :weed_files, :weed_name, :weed_mode, :app_list, :stop_datetime, :start_datetime]

  schema "storage_servers" do
    field :server_name, :string
    field :ip, :string
    field :port, :integer
    field :weed_type, :string
    field :weed_attribute, :string
    field :weed_files, :string
    field :weed_name, :string
    field :weed_mode, :string
    field :app_list, :string
    field :stop_datetime, :utc_datetime_usec
    field :start_datetime, :utc_datetime_usec

    timestamps(type: :utc_datetime_usec, default: Calendar.DateTime.now_utc)
  end

  def get_all_servers do
    StorageServer
    |> order_by(asc: :id)
    |> Repo.all
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end