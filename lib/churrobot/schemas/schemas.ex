defmodule Churrobot.Schemas do
  import Ecto.Query, warn: false
  alias Churrobot.Repo
  alias Churrobot.Schemas.{Counts, History}

  def get_all_counts do
    Repo.all(Counts)
  end

  def get_counts(user) do
    from(
      c in Counts,
      where: c.person_id == ^user
    )
    |> Repo.one() || %Counts{person_id: user, churros: 0}
  end
end
