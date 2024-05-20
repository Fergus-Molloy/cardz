defmodule Cardz.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :description, :string
    field :title, :string
    field :priority, :integer

    belongs_to :column, Cardz.Columns.Column

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description, :column_id, :priority])
    |> validate_required([:title, :column_id, :priority])
  end
end
