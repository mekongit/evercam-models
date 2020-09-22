defmodule Analytics.GeeseCounting do
  @moduledoc """
  The Reports context.
  """
  use Evercam.Schema
  import Ecto.Query, warn: false
  alias Analytics.GeeseCounting

  schema "geese_counting" do

    field :cameraex, :string
    field :snapshot_date, :string
    field :number, :integer
   
    timestamps()
  end

  def get_all_roi(exid) do
    RegionOfInterest
    |> where(cameraex: ^exid)
    |> order_by(asc: :from_date)
    |> AnalyticsRepo.all
  end

  def geese_available_months(exid) do
    query = from g in GeeseCounting,
    select: fragment("substring(?, ?, ?)", g.snapshot_date, 0, 8),
    where: g.cameraex == ^exid,
    group_by: [fragment("substring(?, ?, ?)", g.snapshot_date, 0, 8)],
    order_by: [fragment("substring(?, ?, ?)", g.snapshot_date, 0, 8)]

    query
    |> AnalyticsRepo.all
  end

  def months_all_cameras() do
    query = from g in GeeseCounting,
    select: fragment("substring(?, ?, ?)", g.snapshot_date, 0, 8),
    group_by: [fragment("substring(?, ?, ?)", g.snapshot_date, 0, 8)],
    order_by: [fragment("substring(?, ?, ?)", g.snapshot_date, 0, 8)]

    query
    |> AnalyticsRepo.all
  end

  def geese_data_camera(exid, year, month) do
    date_value = "#{year}-#{month}%"
    query = from g in GeeseCounting,
    where: (g.cameraex ==  ^exid) and (ilike(g.snapshot_date, ^date_value))
    query
    |> order_by(asc: :snapshot_date)
    |> AnalyticsRepo.all
  end

  def detections_all_cameras(year, month) do
    date_value = "#{year}-#{month}%"
    query = from g in GeeseCounting,
    where: ilike(g.snapshot_date, ^date_value)
    query
    |> order_by(asc: :snapshot_date)
    |> AnalyticsRepo.all
  end

  def get_geese_counting!(id), do: AnalyticsRepo.get!(GeeseCounting, id)

  @doc false
  def changeset(%GeeseCounting{} = geese_counting, attrs) do
    geese_counting
    |> cast(attrs, [:cameraex, :snapshot_date, :number])
  end
end
