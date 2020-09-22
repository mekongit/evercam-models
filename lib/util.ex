defmodule Util do
  import Ecto.Changeset, only: [get_field: 2, update_change: 3, put_change: 3]

  def deep_get(map, keys, default \\ nil), do: do_deep_get(map, keys, default)

  defp do_deep_get(nil, _, default), do: default
  defp do_deep_get(%{} = map, [], default) when map_size(map) == 0, do: default
  defp do_deep_get(value, [], _default), do: value
  defp do_deep_get(map, [key|rest], default) do
    map
    |> Map.get(key, %{})
    |> do_deep_get(rest, default)
  end

  def parse_changeset(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
  end

  def slugify(string) when string in [nil, ""], do: ""
  def slugify(string) do
    string |> String.normalize(:nfd) |> String.replace(~r/[^A-z0-9-\s]/u, "")
  end

  def validate_exid(changeset, attr) do
    case get_field(changeset, :exid) do
      nil -> auto_generate_camera_id(changeset, attr)
      _exid -> changeset |> update_change(:exid, &String.downcase/1)
    end
  end

  defp auto_generate_camera_id(changeset, attr) do
    case get_field(changeset, attr) do
      nil ->
        changeset
      name ->
        exid = generate_unique_exid(name)
        put_change(changeset, :exid, exid)
    end
  end

  def generate_unique_exid(name) do
    exid =
      name
      |> slugify
      |> String.replace(" ", "")
      |> String.replace("-", "")
      |> String.downcase
      |> String.slice(0..4)
    "#{exid}-#{Enum.take_random(?a..?z, 5)}"
  end
end
