defmodule Churrobot.Repo.Migrations.CreateCountsTable do
  use Ecto.Migration

  def change do
    create table(:counts) do
      add :person_id, :text, null: false
      add :churros, :integer, null: false, default: 0

      timestamps()
    end
    create index(:counts, [:person_id])
  end
end
