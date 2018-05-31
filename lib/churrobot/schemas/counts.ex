defmodule Churrobot.Schemas.Counts do
  use Ecto.Schema

  schema "counts" do
    field :person_id, :string
    field :churros, :integer, default: 0

    timestamps()
  end
end
