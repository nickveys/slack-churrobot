defmodule Churrobot.Counter do
  use GenServer

  ## Client API

  def start_link(initial \\ %{}) do
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def credit(user_id, amount) do
    GenServer.call(__MODULE__, {:credit, user_id, amount})
  end

  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  ## Server Callbacks

  def init(initial) do
    {:ok, initial}
  end

  def handle_call({:credit, user_id, amount}, _from, value) do
    new_value = Map.update(value, user_id, amount, &(&1 + amount))
    {:reply, Map.get(new_value, user_id), new_value}
  end

  def handle_call(:get_all, _from, value) do
    {:reply, value, value}
  end
end
