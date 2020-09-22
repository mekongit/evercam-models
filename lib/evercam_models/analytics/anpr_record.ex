defmodule Analytics.ANPRRecord do
  use Evercam.Schema

  @fields [:cameraex, :capture_time, :plate_number, :pic_name, :direction]
  @derive {Jason.Encoder, except: [:__meta__, :__struct__]}

  schema "anpr_records" do
    field(:cameraex, :string)
    field(:capture_time, :utc_datetime)
    field(:plate_number, :string)
    field(:pic_name, :string)
    field(:direction, :string)

    timestamps()
  end

  def by_cameraex(cameraex) do
    __MODULE__
    |> where(cameraex: ^cameraex)
    |> AnalyticsRepo.all()
  end

  def changeset(schema, params \\ []) do
    schema
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> unique_constraint(:pic_name)
  end
end
