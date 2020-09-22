defmodule Sim do
  use Evercam.Schema

  @required_fields [:number, :name, :addon, :allowance, :volume_used, :sim_provider, :yesterday_volume_used, :percentage_used, :remaning_days, :last_log_reading_at, :last_bill_date, :last_sms, :last_sms_date, :sms_since_last_bill, :status, :user_id]
  @optional_fields [:camera_id]

  schema "sims" do
    belongs_to :user, User
    belongs_to :camera, Camera
    has_many :messages, Message

    field :number, :string
    field :name, :string
    field :addon, :string
    field :allowance, :string
    field :volume_used, :string
    field :sim_provider, :string
    field :yesterday_volume_used, :string
    field :percentage_used, :float
    field :remaning_days, :string
    field :last_log_reading_at, :naive_datetime
    field :last_bill_date, :string
    field :last_sms, :string
    field :last_sms_date, :string
    field :sms_since_last_bill, :integer
    field :status, :string

    timestamps()
  end

  def get_single_sim(number) do
    Sim
    |> where(number: ^number)
    |> Repo.one
  end

  def get_sim!(id), do: Repo.get!(Sim, id)

  def get_sims() do
    Sim
    |> Repo.all
  end

  def get_sims_by_user(user_id) do
    Sim
    |> where(user_id: ^user_id)
    |> Repo.all
  end

  @doc false
  def changeset(%Sim{} = sim, attrs) do
    sim
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
