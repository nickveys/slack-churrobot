defmodule Churrobot.Bot do
  use Slack

  def handle_connect(_slack, state), do: {:ok, state}

  def handle_event(message, slack, state) do
    case Churrobot.Interpreter.interpret(message, slack) do
      {:ok, text} ->
        send_message(text, message.channel, slack)

      _ ->
        nil
    end

    {:ok, state}
  end
end
