defmodule Churrobot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Churrobot.Supervisor]
    Supervisor.start_link(children(Mix.env()), opts)
  end

  defp children(:test) do
    [
      {Churrobot.Counter, %{}}
    ]
  end

  defp children(_) do
    [
      {Churrobot.Counter, %{}},
      %{
        id: Slack.Bot,
        start: {Slack.Bot, :start_link, [Churrobot.Bot, [], slack_token()]}
      }
    ]
  end

  defp slack_token do
    Application.get_env(:churrobot, Churrobot.Bot)[:token]
  end
end
