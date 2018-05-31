defmodule Churrobot.Repo.Migrations.CreateHistoryTable do
  use Ecto.Migration

  def change do
    create table(:history) do
      add :mentioned_by_id, :text, null: false
      add :mentioned_id, :text, null: false
      add :amount, :integer, null: false

      timestamps()
    end
    create index(:history, [:mentioned_by_id, :mentioned_id])
  end
end
