defmodule Message do
  use Evercam.Schema

  @required_fields [:to, :from, :message_id, :status, :text, :type, :user_id, :sim_id]
  @optional_fields [:delivery_datetime]

  schema "sms_messages" do
    belongs_to :user, User
    belongs_to :sim, Sim

    field :from, :string
    field :message_id, :string
    field :status, :string
    field :text, :string
    field :to, :string
    field :type, :string
    field :delivery_datetime, :naive_datetime

    timestamps()
  end

  def get_message(message_id) do
    Message
    |> where(message_id: ^message_id)
    |> Repo.one
  end

  def messages_by_sim(sim, from, to) do
    Message
    |> where(sim_id: ^sim.id)
    |> where([m], m.inserted_at >= ^from and m.inserted_at <= ^to)
    |> preload(:user)
    |> order_by([m], desc: m.inserted_at)
    |> Repo.all
  end

  def get_single_sim_messages(number) do
    query = from l in Message,
      where: (l.from == ^number or l.to == ^number)
    query
    |> order_by(desc: :inserted_at)
    |> limit(10)
    |>  Repo.all
  end

  def get_sms_count(number, current_date) do
    Message
    |> where([c], (c.from == ^number or c.to == ^number) and (c.inserted_at  >= ^current_date) and (c.type == "MO"))
    |> Repo.all
    |> Enum.count
  end

  def get_last_message_details(number) do
    Message
    |> where([c], (c.from == ^number or c.to == ^number) and (c.type == "MO"))
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> Repo.one
  end

  @doc false
  def changeset(%Message{} = message, params) do
    message
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
