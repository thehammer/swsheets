defmodule EdgeBuilder.Mixfile do
  use Mix.Project

  def project do
    [app: :edge_builder,
     version: "0.0.1",
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {EdgeBuilder, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:comeonin, "~> 3.2"},
      {:cowboy, "~> 1.1.2"},
      {:ex_spec, "~> 2.0.1", only: :test},
      {:floki, "~> 0.19", only: :test},
      {:gettext, "~> 0.13.1"},
      {:httpoison, "~> 0.13.0"},
      {:inflex, "~> 1.9.0" },
      {:mock, "~> 0.3.1", only: :test},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_ecto, "~> 3.3.0"},
      {:phoenix_html, "~> 2.10.5"},
      {:phoenix_live_reload, "~> 1.1.3"},
      {:phoenix_pubsub, "~> 1.0.2"},
      {:plug, "~>1.4.3"},
      {:postgrex, "~> 0.13.3"},
      {:scrivener_ecto, "~> 1.3.0"},
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
