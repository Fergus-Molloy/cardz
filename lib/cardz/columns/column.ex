defmodule Cardz.Columns.Column do
  use Ecto.Schema
  import Ecto.Changeset

  schema "columns" do
    field :title, :string

    belongs_to :project, Cardz.Projects.Project

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(column, attrs) do
    column
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
