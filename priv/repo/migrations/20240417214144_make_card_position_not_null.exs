defmodule Cardz.Repo.Migrations.MakeCardPositionNotNull do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      modify :position, :integer, null: false, from: {:integer, null: true}
    end
  end
end
