defmodule Churrobot.Repo.Migrations.MakeCounts64bit do
  use Ecto.Migration

  def down do
    alter table(:history) do
      modify :amount, :integer, null: false
    end
    alter table(:counts) do
      modify :churros, :integer, null: false, default: 0
    end
  end

  def up do
    alter table(:history) do
      modify :amount, :bigint, null: false
    end
    alter table(:counts) do
      modify :churros, :bigint, null: false, default: 0
    end
  end
end
