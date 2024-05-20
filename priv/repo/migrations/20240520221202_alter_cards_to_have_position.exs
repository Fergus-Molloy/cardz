defmodule Cardz.Repo.Migrations.AlterCardsToHavePosition do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :priority, :integer, null: false
    end

    create index(:cards, [:priority])
  end
end
