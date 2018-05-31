use Mix.Config

config :churrobot, Churrobot.Repo,
  username: "postgres",
  password: "postgres",
  database: "churrobot_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
