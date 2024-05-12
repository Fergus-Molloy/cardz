defmodule Cardz.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :title, :string
      add :description, :string
      add :status, references(:columns, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:cards, [:status])
  end
end
