defmodule Cardz.Repo.Migrations.AddCardPosition do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :position, :integer
    end
  end
end
