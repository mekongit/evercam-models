defmodule Battery do
  use Evercam.Schema
  import Ecto.Query, warn: false

  schema "batteries" do
    has_many :battery_readings, BatteryReading
    belongs_to :user, User

    field :name, :string
    field :source_url, :string
    field :active, :boolean, default: true

    timestamps()
  end

  def list_batteries() do
    Battery
    |> order_by(desc: :inserted_at)
    |> Repo.all
  end

  def list_active_batteries() do
    Battery
    |> where(active: true)
    |> Repo.all
  end

  def get_batteries_by_user(user_id) do
    Battery
    |> where(user_id: ^user_id)
    |> Repo.all
  end

  def get_battery!(id), do: Repo.get!(Battery, id)

  def create_battery(attrs \\ %{}) do
    %Battery{}
    |> Battery.changeset(attrs)
    |> Repo.insert()
  end

  def update_battery(%Battery{} = battery, attrs) do
    battery
    |> Battery.changeset(attrs)
    |> Repo.update()
  end

  def delete_battery(%Battery{} = battery) do
    Repo.delete(battery)
  end

  @doc false
  def changeset(battery, attrs) do
    battery
    |> cast(attrs, [:name, :source_url, :user_id, :active])
    |> validate_required([:name, :source_url, :user_id])
  end
end
