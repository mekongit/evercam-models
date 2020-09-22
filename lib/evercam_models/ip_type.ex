defmodule InetType do
  @behaviour Ecto.Type

  def type, do: :inet
  def cast(term), do: {:ok, term}
  def dump(term), do: {:ok, term}
  def load(term), do: {:ok, term}
end
