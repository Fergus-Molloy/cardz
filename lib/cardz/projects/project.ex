defmodule Cardz.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :abbr, :string
    field :description, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :description, :abbr])
    |> validate_required([:title, :description, :abbr])
    |> unique_constraint(:abbr)
    |> unique_constraint(:title)
  end
end
