defmodule Churrobot.Interpreter do
  alias Churrobot.Counter

  def interpret(message = %{type: "message"}, slack) do
    if mentions_me?(message, slack) do
      message
      |> extract(slack)
      |> perform(message)
    else
      {:ignore}
    end
    # Counter.credit(id, 1)
  end
  def interpret(_, _), do: {:ignore}

  defp extract(%{text: text}, %{me: %{id: id}}) do
    text
    |> text_without_my_mention(id)
  end

  defp mentions_me?(%{text: text}, %{me: %{id: id}}) do
    Regex.match?(~r/#{id}/, text)
  end

  defp perform("help", _) do
    {:ok, ~s"""
    `show all` - show everyone's churros
    `show me`, `show` - show your own churros
    `show @user` - show a specific user's churros
    `give @user 1` - give specific user 1 churro
    """}
  end

  defp perform("show all", _) do
    {:ok, "Show everything!"}
  end

  defp perform("show me", message) do
    perform("show", message)
  end

  defp perform("show", %{user: user}) do
    {:ok, "Show stuff for <@#{user}>!"}
  end

  defp perform("give" <> rest, _) do
    ~r/\<\@(?<id>\w+)\>\s+(?<amount>\d+)/
    |> Regex.named_captures(rest)
    |> perform_give
  end

  defp perform(command, _) do
    {:ok, "I don't know what '#{command}' means 🤷‍♂️"}
  end

  defp perform_give(%{"id" => who, "amount" => amount}) do
    result = Counter.credit(who, String.to_integer(amount))
    {:ok, "I gave <@#{who}> #{amount} churro(s), they have #{result}!"}
  end
  defp perform_give(nil), do: {:ok, "Huh? Try `give @user 1`"}

  defp text_without_my_mention(text, id) do
    ~r/\<\@#{id}\>/
    |> Regex.replace(text, "")
    |> String.trim
  end
end
