defmodule Churrobot.MixProject do
  use Mix.Project

  def project do
    [
      app: :churrobot,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
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
end
