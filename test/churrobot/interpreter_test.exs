defmodule Churrobot.InterpreterTest do
  use ExUnit.Case, async: true
  alias Churrobot.Interpreter
  doctest Interpreter

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Churrobot.Repo)

    message = %{
      text: "",
      type: "message",
      user: "USER"
    }

    slack = %{
      me: %{
        id: "BOT"
      }
    }

    {:ok, message: message, slack: slack}
  end

  test "ignored message", %{slack: slack} do
    assert {:ignore} = Interpreter.interpret(%{type: "other"}, slack)
  end

  test "unknown command", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> dance"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "I don't know what 'dance' means 🤷‍♂️"} = result
  end

  test "help command", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> help"}
    assert {:ok, output} = Interpreter.interpret(message, slack)
    assert output =~ ~r/show all/
    assert output =~ ~r/show me/
    assert output =~ ~r/show @user/
    assert output =~ ~r/give @user/
  end

  test "show all command empty", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show all"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "Nobody has any churros!"} = result
  end

  test "show all command with entries", %{message: message, slack: slack} do
    Interpreter.interpret(%{message | text: "<@BOT> give <@BAR> 10"}, slack)
    Interpreter.interpret(%{message | text: "<@BOT> give <@BAZ> 1"}, slack)
    Interpreter.interpret(%{message | text: "<@BOT> give <@FLUB> 49"}, slack)
    Interpreter.interpret(%{message | text: "<@BOT> give <@BAR> 5"}, slack)
    Interpreter.interpret(%{message | text: "<@BOT> give <@FOO> 5"}, slack)
    Interpreter.interpret(%{message | text: "<@BOT> give <@FLUB> 1"}, slack)
    Interpreter.interpret(%{message | text: "<@BOT> give <@GOO> 25"}, slack)

    assert {:ok, output} = Interpreter.interpret(%{message | text: "<@BOT> show all"}, slack)

    output =
      output
      |> String.trim()
      |> String.split("\n")
      |> Enum.sort()

    expected =
      """
      <@FOO> has 5 churros
      <@BAR> has 15 churros
      <@BAZ> has 1 churro
      <@FLUB> has 50 churros
      <@GOO> has 25 churros
      """
      |> String.trim()
      |> String.split("\n")
      |> Enum.sort()

    assert expected == output
  end

  test "show command empty", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "<@USER> has 0 churros"} = result
  end

  test "show command with entries", %{message: message, slack: slack} do
    Interpreter.interpret(%{message | text: "<@BOT> give <@USER> 10", user: "OTHER"}, slack)
    result = Interpreter.interpret(%{message | text: "<@BOT> show"}, slack)
    assert {:ok, "<@USER> has 10 churros"} = result
  end

  test "show me command empty", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show me"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "<@USER> has 0 churros"} = result
  end

  test "show me command with entries", %{message: message, slack: slack} do
    Interpreter.interpret(%{message | text: "<@BOT> give <@USER> 7", user: "OTHER"}, slack)
    result = Interpreter.interpret(%{message | text: "<@BOT> show me"}, slack)
    assert {:ok, "<@USER> has 7 churros"} = result
  end

  test "give command", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> give <@OTHER> 25"}
    result = Interpreter.interpret(message, slack)
    expected = "<@USER> gave <@OTHER> 25 churros, they now have 25!"
    assert {:ok, ^expected} = result
  end

  test "give command with 0 amount"

  test "give command multiple times", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> give <@OTHER> 25"}
    Interpreter.interpret(message, slack)
    Interpreter.interpret(message, slack)
    Interpreter.interpret(message, slack)
    result = Interpreter.interpret(message, slack)
    expected = "<@USER> gave <@OTHER> 25 churros, they now have 100!"
    assert {:ok, ^expected} = result
  end

  test "give to self command", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> give <@USER> 10"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "Hey look, <@USER> tried to give themself churros!"} = result
  end
end
