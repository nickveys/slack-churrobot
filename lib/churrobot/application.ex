defmodule Churrobot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      %{
        id: Slack.Bot,
        start: {Slack.Bot, :start_link, [Churrobot.Bot, [], slack_token()]}
      },
      {Churrobot.Counter, %{}},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Churrobot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp slack_token do
    Application.get_env(:churrobot, Churrobot.Bot)[:token]
  end
end
