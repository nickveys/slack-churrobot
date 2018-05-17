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
  end

  def interpret(_, _), do: {:ignore}

  defp extract(%{text: text}, %{me: %{id: id}}) do
    ~r/\<\@#{id}\>/
    |> Regex.replace(text, "", global: false)
    |> String.trim()
  end

  defp inflect(word, number), do: Inflex.inflect(word, number)

  defp mentions_me?(%{text: text}, %{me: %{id: id}}) do
    Regex.match?(~r/#{id}/, text)
  end

  defp mentions_me?(_, _), do: false

  defp perform("help", _) do
    {:ok,
     ~s"""
     `show all` - show everyone's churros
     `show me`, `show` - show your own churros
     `show @user` - show a specific user's churros
     `give @user 1` - give specific user 1 churro
     """}
  end

  defp perform("show all", _) do
    text =
      Counter.get_all()
      |> Enum.map(fn {k, v} -> "<@#{k}> has #{v} #{inflect("churro", v)}" end)
      |> Enum.join("\n")

    if "" == text do
      {:ok, "Nobody has any churros!"}
    else
      {:ok, text}
    end
  end

  defp perform("show me", message) do
    perform("show", message)
  end

  defp perform("show", %{user: user}) do
    {:ok, "Show stuff for <@#{user}>!"}
  end

  defp perform("give" <> rest, %{user: user}) do
    ~r/\<\@(?<id>\w+)\>\s+(?<amount>\d+)/
    |> Regex.named_captures(rest)
    |> perform_give(user)
  end

  defp perform(command, _) do
    {:ok, "I don't know what '#{command}' means 🤷‍♂️"}
  end

  defp perform_give(%{"id" => to, "amount" => amount}, from) do
    if from == to do
      {:ok, "Hey look, <@#{from}> tried to give themself churros!"}
    else
      result = Counter.credit(to, String.to_integer(amount))

      {:ok,
       "<@#{from}> gave <@#{to}> #{amount} #{inflect("churro", result)}, they now have #{result}!"}
    end
  end

  defp perform_give(nil, _), do: {:ok, "Huh? Try `give @user 1`"}
end
