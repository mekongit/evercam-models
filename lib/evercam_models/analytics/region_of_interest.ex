defmodule Analytics.RegionOfInterest do
  @moduledoc """
  The Reports context.
  """
  use Evercam.Schema
  import Ecto.Query, warn: false
  alias Analytics.RegionOfInterest

  schema "regionof_interest" do

    field :cameraex, :string
    field :roi_wideness, :integer
    field :roi_type, :string
    field :x, :float
    field :y, :float
    field :x2, :float
    field :y2, :float
    field :from_date, :string

    timestamps()
  end

  def get_last_record(start_date, exid) do
    query = from u in RegionOfInterest,
      where: (u.from_date <= ^start_date) and (u.cameraex == ^exid),
      select: u.from_date,
      order_by: [desc: :from_date]
    query
    |> limit(1)
    |> AnalyticsRepo.one
  end

  def get_last_rectangular_record(start_date, exid) do
    query = from u in RegionOfInterest,
      where: (u.from_date <= ^start_date) and (u.cameraex == ^exid) and (u.roi_type == "rectangular"),
      order_by: [desc: :from_date]
    query
    |> limit(1)
    |> AnalyticsRepo.one
  end

  def get_coordinates_record(start_date, exid) do
    query = from u in RegionOfInterest,
      where: (u.from_date == ^start_date) and (u.cameraex == ^exid),
      order_by: [desc: :from_date]
    query
    |> AnalyticsRepo.all
  end

  def get_region_of_interest!(id), do: AnalyticsRepo.get!(RegionOfInterest, id)

  def get_all_roi(exid) do
    RegionOfInterest
    |> where(cameraex: ^exid)
    |> order_by(asc: :from_date)
    |> AnalyticsRepo.all
  end

  @doc false
  def changeset(%RegionOfInterest{} = region_of_Interest, attrs) do
    region_of_Interest
    |> cast(attrs, [:cameraex, :roi_wideness, :roi_type, :x, :y, :x2, :y2, :from_date])
    |> validate_required(:roi_type, [message: "Drawing type cannot be empty."])
    |> validate_required(:x, [message: "X1 cannot be empty."])
    |> validate_required(:y, [message: "Y1 type cannot be empty."])
    |> validate_required(:x2, [message: "X2 type cannot be empty."])
    |> validate_required(:y2, [message: "Y2 type cannot be empty."])
    |> validate_required(:from_date, [message: "Start date type cannot be empty."])
  end
end
