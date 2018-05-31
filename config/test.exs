use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

config :churrobot, Churrobot.Repo,
  username: "postgres",
  password: "postgres",
  database: "churrobot_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
