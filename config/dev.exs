use Mix.Config

config :churrobot, Churrobot.Repo,
  username: "postgres",
  password: "postgres",
  database: "churrobot_dev",
  hostname: "localhost",
  pool_size: 10
