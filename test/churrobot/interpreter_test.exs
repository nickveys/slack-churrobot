defmodule Churrobot.InterpreterTest do
  # , async: true
  use ExUnit.Case
  alias Churrobot.Interpreter
  doctest Interpreter

  setup do
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
    result = Interpreter.interpret(message, slack)
    assert {:ok, ""} = result
  end

  test "show all command empty", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show all"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "Nobody has any churros!"} = result
  end

  test "show all command with entries", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show all"}
    result = Interpreter.interpret(message, slack)

    assert {:ok,
            ~s"""
            <@FOO> has 5 churros
            <@BAR> has 15 churros
            <@BAZ> has 1 churro
            """} = result
  end

  test "show command empty", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "<@USER> has no churros"} = result
  end

  test "show command with entries", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "<@USER> has 10 churros"} = result
  end

  test "show me command empty", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show me"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "<@USER> has no churros"} = result
  end

  test "show me command with entries", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> show me"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "<@USER> has 7 churros"} = result
  end

  test "give command", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> give <@OTHER> 25"}
    result = Interpreter.interpret(message, slack)
    expected = "<@USER> gave <@OTHER> 25 churros, they now have 25!"
    assert {:ok, expected} = result
  end

  test "give command multiple times", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> give <@OTHER> 25"}
    result = Interpreter.interpret(message, slack)
    result = Interpreter.interpret(message, slack)
    result = Interpreter.interpret(message, slack)
    result = Interpreter.interpret(message, slack)
    expected = "<@USER> gave <@OTHER> 25 churros, they now have 100!"
    assert {:ok, expected} = result
  end

  test "give to self command", %{message: message, slack: slack} do
    message = %{message | text: "<@BOT> give <@USER> 10"}
    result = Interpreter.interpret(message, slack)
    assert {:ok, "Hey look, <@USER> tried to give themself churros!"} = result
  end
end
