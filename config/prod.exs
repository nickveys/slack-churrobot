use Mix.Config

config :churrobot, Churrobot.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: 20
