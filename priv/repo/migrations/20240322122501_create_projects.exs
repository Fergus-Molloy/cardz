defmodule Cardz.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string, null: false
      add :description, :text
      add :abbr, :string, size: 5, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:projects, [:abbr])
    create unique_index(:projects, [:title])
  end
end
