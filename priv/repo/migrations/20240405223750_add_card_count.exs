defmodule Cardz.Repo.Migrations.AddCardCount do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :number, :integer
    end

    alter table(:projects) do
      add :count, :integer
    end
  end
end
