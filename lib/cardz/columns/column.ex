defmodule Cardz.Columns.Column do
  use Ecto.Schema
  import Ecto.Changeset

  schema "columns" do
    field :description, :string
    field :title, :string

    belongs_to :project, Cardz.Projects.Project
    has_many :cards, Cardz.Cards.Card

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(column, attrs) do
    column
    |> cast(attrs, [:title, :description, :project_id])
    |> validate_required([:title, :project_id])
  end
end
