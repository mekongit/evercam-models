defmodule EvercamModels.MixProject do
  use Mix.Project

  def project do
    [
      app: :evercam_models,
      version: "0.1.1",
      elixir: "~> 1.10.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto_sql, :postgrex],
      mod: {EvercamModels.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.1.6"},
      {:postgrex, ">= 0.0.0"},
      {:geo, "~> 3.0"},
      {:geo_postgis, "~> 3.0"},
      {:jason, "~> 1.1"},
      {:calendar, "~> 0.17.6"},
      {:bcrypt_elixir, "~> 2.0"},
      {:uuid, "~> 1.1.7"},
      {:con_cache, "~> 0.13.0"},
      {:html_sanitize_ex, "~> 1.3.0"},
      {:joken, "~> 2.0"},
      {:timex, "~> 3.5"}
    ]
  end
end
