defmodule Churrobot.Bot do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message, slack, state) do
    case Churrobot.Interpreter.interpret(message, slack) do
      {:ok, text} ->
        send_message(text, message.channel, slack)
      _ -> nil
    end
    {:ok, state}
  end

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end

# @churrobot show all
# >> dump everything
# @churrobot show (me)
# >> dump mine
# @churrobot show @mention
# >> dump specific user
# @churrobot @mention +1
# >> reply with new amount
