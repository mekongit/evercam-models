defmodule CameraActivity do
  use Evercam.Schema

  @required_fields [:camera_id, :action]
  @optional_fields [:access_token_id, :camera_exid, :name, :action, :extra, :done_at, :user_id]

  schema "camera_activities" do
    belongs_to :camera, Camera
    belongs_to :access_token, AccessToken

    field :action, :string
    field :done_at, :utc_datetime_usec, default: Calendar.DateTime.now_utc
    field :extra, Evercam.Types.JSON
    field :camera_exid, :string
    field :user_id, :integer
    field :name, :string
  end

  def get_logs_for_days(days, account, offline) do
    {day, ""} = days |> Integer.parse
    days_in_seconds = day * 24 * 60 * 60
    utc_now =
      Calendar.DateTime.now_utc
      |> Calendar.DateTime.to_erl
      |> Calendar.DateTime.from_erl!("Etc/UTC", {123456, 6})

    from_date =
      utc_now
      |> Calendar.DateTime.advance!( - days_in_seconds)

    accounts_cameras =
      Camera
      |> where(owner_id: ^account)
      |> where([cam], cam.status not in ^offline_only(offline))
      |> Repo.all

    camera_ids =
      accounts_cameras
      |> Enum.map(fn(camera) -> camera.id end)

    all_logs =
      CameraActivity
      |> where([c], c.camera_id in ^camera_ids)
      |> where([c], c.done_at >= ^from_date and c.done_at <= ^utc_now)
      |> where([c], c.action in ["online", "offline"])
      |> order_by([c], asc: c.done_at)
      |> SnapshotRepo.all

    camera_logs =
      Enum.map(accounts_cameras, fn (camera) ->
        %{
          camera_name: camera.name,
          status: camera.status,
          created_at: camera.created_at |> Timex.to_datetime,
          logs: map_logs(all_logs, camera.id)
        }
      end)

    formated_data =
      camera_logs
      |> Enum.map(fn (log) ->
        %{
          measure: create_measure(log.camera_name, log.status),
          data: fromat_logs(log.status, log.logs, "Etc/UTC", log.created_at, days)
        }
      end)

    formated_data
  end

  defp offline_only(param) when param in [true, "true"], do: ["project_finished", "ftp", "waiting", "on_hold", "under_maintenance", "online"]
  defp offline_only(param) when param in [false, "false"], do: ["project_finished", "ftp", "waiting", "on_hold", "under_maintenance"]

  defp set_action_single(log) do
    case log.action do
      "online" -> "offline"
      _ -> "online"
    end
  end

  defp digit_status(action) do
    if action == "online" do
      1
    else
      0
    end
  end

  defp create_measure(camera_name, status) do
    if status == "online" do
      camera_name
    else
      "#{camera_name} ?"
    end
  end

  defp map_logs(all_logs, camera_id) do
    if no_in_logs(all_logs, camera_id) == nil do
      []
    else
      for log <- all_logs, log.camera_id == camera_id, do: %{done_at: log.done_at, action: log.action}
    end
  end

  defp no_in_logs(logs, camera_id) do
    Enum.find(logs, fn(log) -> log.camera_id == camera_id end)
  end

  defp fromat_logs(status, logs, _timezone, created_at, days) do
    {day, ""} = days |> Integer.parse
    days_in_seconds = day * 24 * 60 * 60
    starting_of_week =
      Calendar.DateTime.now_utc
      |> Timex.beginning_of_day()
      |> Calendar.DateTime.to_erl
      |> Calendar.DateTime.from_erl!("Etc/UTC", {123456, 6})
      |> Calendar.DateTime.advance!( - days_in_seconds)

    no_event_logged =
      case DateTime.compare starting_of_week, created_at do
        :gt -> starting_of_week
        _ -> created_at
      end

    unshift_log =
      case length(logs) >= 1 do
        true ->
          [ %{done_at: no_event_logged, action: logs |> List.first |> set_action_single()} | logs]
        _ ->
          logs
      end

    logs_to_return =
      cond do
        unshift_log == [] && status == "offline" ->
          [[format_date_time(no_event_logged), 0, format_date_time(Calendar.DateTime.now_utc)]]
        unshift_log == [] && status == "online" ->
          [[format_date_time(no_event_logged), 1, format_date_time(Calendar.DateTime.now_utc)]]
        length(unshift_log) > 1 ->
          unshift_log
          |> Enum.with_index
          |> Enum.map(fn({log, index}) ->
            [format_date_time(log.done_at), digit_status(log.action), done_at_with_index(logs, index, "Etc/UTC")]
          end)
      end
    logs_to_return
  end

  defp done_at_with_index(logs, index, _timezone) do
    if index > length(logs) - 1 do
      Calendar.DateTime.now_utc
      |> Calendar.Strftime.strftime("%Y-%m-%d %H:%M:%S")
      |> elem(1)
    else
      Enum.at(logs, index) |> Map.get(:done_at) |> Calendar.Strftime.strftime("%Y-%m-%d %H:%M:%S") |> elem(1)
    end
  end

  defp format_date_time(done_at) do
    done_at
    |> Calendar.Strftime.strftime("%Y-%m-%d %H:%M:%S")
    |> elem(1)
  end

  def get_all(query) do
    query
    |> order_by([c], desc: c.done_at)
    |> SnapshotRepo.all
  end

  def delete_by_camera_id(camera_id) do
    CameraActivity
    |> where(camera_id: ^camera_id)
    |> SnapshotRepo.delete_all
  end

  def for_a_user(user_id, from, to, types) do
    CameraActivity
    |> where(user_id: ^user_id)
    |> where([c], c.done_at >= ^from and c.done_at <= ^to)
    |> with_types_if_specified(types)
    |> order_by([c], desc: c.done_at)
    |> SnapshotRepo.all
  end

  def get_last_on_off_log(camera_id, action \\ ["online", "offline"]) do
    CameraActivity
    |> where(camera_id: ^camera_id)
    |> where([c], c.action in ^action)
    |> order_by(desc: :id)
    |> limit(1)
    |> SnapshotRepo.one
  end

  def with_types_if_specified(query, nil) do
    query
  end
  def with_types_if_specified(query, types) do
    query
    |> where([c], c.action in ^types)
  end

  def changeset(camera_activity, params \\ :invalid) do
    camera_activity
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:camera_id, name: :camera_activities_camera_id_done_at_index)
  end
end
