defmodule Churrobot.Schemas.History do
  use Ecto.Schema

  schema "history" do
    field :mentioned_by_id, :string
    field :mentioned_id, :string
    field :amount, :integer

    timestamps()
  end
end
