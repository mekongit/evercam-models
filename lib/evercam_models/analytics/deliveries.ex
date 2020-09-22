defmodule Analytics.Deliveries do
  use Evercam.Schema
  alias Analytics.Deliveries
  import Ecto.Query, warn: false

  schema "deliveries" do
    field(:timespent, :string)
    field(:cameraex, :string)
    field(:arrived_time, :string)
    field(:left_time, :string)
    field(:detection_type, :string)
    field(:truck_type, :string)
    field(:bounding_box_in, :map)
    field(:bounding_box_out, :map)
    field(:is_public, :boolean)
    field(:origin_id, :integer)
    timestamps(type: :utc_datetime_usec, default: Calendar.DateTime.now_utc())
  end

  def truck_count_records(date, _detection_type, truck_type, exid, opts \\ [show_hidden: false]) do
    date_value = "#{date}%"
    inserted_at = "2019-09-24 17:00:00"

    query =
      from(a in Deliveries,
        where:
          (ilike(a.arrived_time, ^date_value) or ilike(a.left_time, ^date_value)) and
            a.cameraex == ^exid and a.inserted_at >= ^inserted_at and
            a.truck_type in ^truck_type and
            fragment("NOT EXISTS (select 1 from deliveries as b WHERE ?.id = b.origin_id)", a),
        order_by: [asc: a.arrived_time]
      )
      |> show_hidden_filter(opts[:show_hidden])

    query
    |> AnalyticsRepo.all()
  end

  def year_wise_results(_detection_type, truck_type, exid, opts \\ [show_hidden: false]) do
    query =
      from(d in Deliveries,
        select: %{
          year:
            fragment(
              "(case when ? is null then substring(?, ?, ?) else substring(? , ?, ?) end)",
              d.arrived_time,
              d.left_time,
              0,
              5,
              d.arrived_time,
              0,
              5
            ),
          total_in: fragment("sum(case when ? is null then 0 else 1 end)", d.arrived_time),
          total_out: fragment("sum(case when ? is null then 0 else 1 end)", d.left_time),
          avg: fragment("
	      AVG (case
  		  when ? is null or ? is null then null
   		  else ?::timestamp - ?::timestamp
   	      end)::varchar", d.arrived_time, d.left_time, d.left_time, d.arrived_time)
        },
        where:
          d.cameraex == ^exid and
            d.truck_type in ^truck_type and
            fragment("NOT EXISTS (select 1 from deliveries as b WHERE ?.id = b.origin_id)", d),
        group_by: [
          fragment(
            "(case when ? is null then substring(?, ?, ?) else substring(?, ?, ?) end)",
            d.arrived_time,
            d.left_time,
            0,
            5,
            d.arrived_time,
            0,
            5
          )
        ]
      )
      |> show_hidden_filter(opts[:show_hidden])

    query
    |> AnalyticsRepo.all()
  end

  def month_wise_results(_detection_type, truck_type, exid, opts \\ [show_hidden: false]) do
    query =
      from(d in Deliveries,
        select: %{
          month:
            fragment(
              "(case when ? is null then substring(?, ?, ?) else substring(? , ?, ?) end)",
              d.arrived_time,
              d.left_time,
              0,
              8,
              d.arrived_time,
              0,
              8
            ),
          total_in: fragment("sum(case when ? is null then 0 else 1 end)", d.arrived_time),
          total_out: fragment("sum(case when ? is null then 0 else 1 end)", d.left_time),
          avg: fragment("
	      AVG (case
  		  when ? is null or ? is null then null
   		  else ?::timestamp - ?::timestamp
   	      end)::varchar", d.arrived_time, d.left_time, d.left_time, d.arrived_time)
        },
        where:
          d.cameraex == ^exid and
            d.truck_type in ^truck_type and
            fragment("NOT EXISTS (select 1 from deliveries as b WHERE ?.id = b.origin_id)", d),
        group_by: [
          fragment(
            "(case when ? is null then substring(?, ?, ?) else substring(?, ?, ?) end)",
            d.arrived_time,
            d.left_time,
            0,
            8,
            d.arrived_time,
            0,
            8
          )
        ]
      )
      |> show_hidden_filter(opts[:show_hidden])

    query
    |> AnalyticsRepo.all()
  end

  def day_wise_results(_detection_type, truck_type, exid, opts \\ [show_hidden: false]) do
    query =
      from(d in Deliveries,
        select: %{
          date:
            fragment(
              "(case when ? is null then substring(?, ?, ?) else substring(? , ?, ?) end)",
              d.arrived_time,
              d.left_time,
              0,
              11,
              d.arrived_time,
              0,
              11
            ),
          total_in: fragment("sum(case when ? is null then 0 else 1 end)", d.arrived_time),
          total_out: fragment("sum(case when ? is null then 0 else 1 end)", d.left_time),
          avg: fragment("
	      AVG (case
  		  when ? is null or ? is null then null
   		  else ?::timestamp - ?::timestamp
   	      end)::varchar", d.arrived_time, d.left_time, d.left_time, d.arrived_time)
        },
        where:
          d.cameraex == ^exid and
            d.truck_type in ^truck_type and
            fragment("NOT EXISTS (select 1 from deliveries as b WHERE ?.id = b.origin_id)", d),
        group_by: [
          fragment(
            "(case when ? is null then substring(?, ?, ?) else substring(?, ?, ?) end)",
            d.arrived_time,
            d.left_time,
            0,
            11,
            d.arrived_time,
            0,
            11
          )
        ]
      )
      |> show_hidden_filter(opts[:show_hidden])

    query
    |> AnalyticsRepo.all()
  end

  def check_records_exist(exid) do
    Deliveries
    |> select([d], d.arrived_time)
    |> where(cameraex: ^exid)
    |> order_by(asc: :arrived_time)
    |> limit(1)
    |> AnalyticsRepo.one()
  end

  def get_deliveries_records!(id), do: AnalyticsRepo.get!(Deliveries, id)

  @doc false
  def changeset(%Deliveries{} = deliveries, attrs) do
    deliveries
    |> cast(attrs, [
      :timespent,
      :cameraex,
      :arrived_time,
      :left_time,
      :detection_type,
      :truck_type,
      :is_public,
      :origin_id
    ])
    |> unique_constraint(:origin_id)
  end

  @doc """
  Update a gate report event with new parameters
  """
  def update(cameraex, id, params) do
    old_event = retreive_event_for_update(cameraex, id)

    if is_integer(old_event.origin_id) do
      update_already_edited_event(old_event, params)
    else
      insert_edited_event(old_event, params)
    end
  end

  defp retreive_event_for_update(cameraex, id) do
    from(a in Deliveries,
      where:
        a.cameraex == ^cameraex and
          a.id == ^id and
          fragment("NOT EXISTS (select 1 from deliveries as b WHERE ?.id = b.origin_id)", a)
    )
    |> AnalyticsRepo.one!()
  end

  defp update_already_edited_event(%Deliveries{} = old_event, params) do
    old_event |> changeset(params) |> AnalyticsRepo.update()
  end

  defp insert_edited_event(%Deliveries{} = old_event, params) do
    old_params =
      old_event
      |> Map.from_struct()
      |> Map.delete(:id)
      |> Map.delete(:updated_at)
      |> Map.delete(:inserted_at)
      |> Map.delete(:arrived_time)
      |> Map.delete(:left_time)

    old_changeset = %Deliveries{} |> changeset(old_params)
    new_changeset = %Deliveries{} |> changeset(params) |> change(%{origin_id: old_event.id})

    AnalyticsRepo.insert(merge(old_changeset, new_changeset))
  end

  defp show_hidden_filter(query, true), do: query
  defp show_hidden_filter(query, _), do: query |> where([a], a.is_public == true)
end
