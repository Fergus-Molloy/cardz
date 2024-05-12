defmodule Cardz.Columns.Column do
  use Ecto.Schema
  import Ecto.Changeset

  schema "columns" do
    field :description, :string
    field :title, :string
    field :project_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(column, attrs) do
    column
    |> cast(attrs, [:title, :description, :project_id])
    |> validate_required([:title, :project_id])
  end
end
