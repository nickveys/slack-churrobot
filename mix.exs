defmodule Churrobot.MixProject do
  use Mix.Project

  def project do
    [
      app: :churrobot,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Churrobot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.2"},
      {:inflex, "~> 1.10"},
      {:slack, "~> 0.12"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  defp aliases do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
