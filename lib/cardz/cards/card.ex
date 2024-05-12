defmodule Cardz.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :description, :string
    field :title, :string
    field :status, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
