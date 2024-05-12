defmodule Cardz.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :title, :string
      add :description, :string
      add :column_id, references(:columns, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:cards, [:column_id])
  end
end
