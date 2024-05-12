defmodule Cardz.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end
  end
end
