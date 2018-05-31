defmodule Churrobot.Schemas.Counts do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counts" do
    field(:person_id, :string)
    field(:churros, :integer, default: 0)

    timestamps()
  end

  def give_changeset(counts, amount) do
    counts
    |> cast(%{churros: counts.churros + amount}, [:churros])
    |> validate_number(:churros, greater_than: 0)
  end
end
