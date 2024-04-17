defmodule Cardz.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :description, :string
    field :title, :string
    field :number, :integer
    field :position, :integer

    belongs_to :column, Cardz.Columns.Column

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description, :number, :position])
    |> validate_required([:title, :number, :position])
    |> validate_number(:number, greater_than: 0)
    |> validate_number(:position, greater_than: 0)
  end
end
