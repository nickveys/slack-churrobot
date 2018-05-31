defmodule Churrobot.Schemas.History do
  use Ecto.Schema
  import Ecto.Changeset

  schema "history" do
    field(:mentioned_by_id, :string)
    field(:mentioned_id, :string)
    field(:amount, :integer)

    timestamps()
  end

  def creation_changeset(params \\ %{}) do
    %Churrobot.Schemas.History{}
    |> cast(params, [:mentioned_by_id, :mentioned_id, :amount])
    |> validate_required([:mentioned_by_id, :mentioned_id, :amount])
    |> validate_number(:amount, greater_than: 0)
  end
end
