defmodule Cardz.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :abbr, :string
    field :description, :string
    field :title, :string
    field :count, :integer

    has_many :columns, Cardz.Columns.Column
    has_many :cards, through: [:columns, :cards]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :description, :abbr])
    |> validate_required([:title, :abbr])
    |> unique_constraint(:abbr)
    |> unique_constraint(:title)
    |> validate_length(:abbr, max: 5)
  end
end
