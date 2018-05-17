defmodule ChurrobotTest do
  use ExUnit.Case
  doctest Churrobot

  test "greets the world" do
    assert Churrobot.hello() == :world
  end
end
