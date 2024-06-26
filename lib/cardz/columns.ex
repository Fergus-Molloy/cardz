defmodule Cardz.Columns do
  @moduledoc """
  The Columns context.
  """

  import Ecto.Query, warn: false
  alias Cardz.Repo

  alias Cardz.Columns.Column

  @doc """
  Returns the list of columns.

  ## Examples

      iex> list_columns()
      [%Column{}, ...]

  """
  def list_columns do
    Repo.all(Column)
  end

  def list_columns_for_project(id, :preload) do
    Repo.all(from(col in Column, where: col.project_id == ^id, preload: :cards))
  end

  def list_columns_for_project(id) do
    Repo.all(from(col in Column, where: col.project_id == ^id))
  end

  def count_cards(id) do
    query =
      from(card in Cardz.Cards.Card,
        where: card.column_id == ^id,
        select: count(card.id)
      )

    Repo.one(query)
  end

  @doc """
  Gets a single column.

  Raises `Ecto.NoResultsError` if the Column does not exist.

  ## Examples

      iex> get_column!(123)
      %Column{}

      iex> get_column!(456)
      ** (Ecto.NoResultsError)

  """
  def get_column!(id), do: Repo.get!(Column, id)

  def get_first_column(project_id),
    do: Repo.one(from(col in Column, where: col.project_id == ^project_id, limit: 1))

  def get_cards(id),
    do:
      Repo.all(
        from col in Column,
          left_join: card in assoc(col, :cards),
          where: col.id == ^id,
          preload: [:cards]
      )

  @doc """
  Creates a column.

  ## Examples

      iex> create_column(%{field: value})
      {:ok, %Column{}}

      iex> create_column(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_column(attrs \\ %{}) do
    %Column{}
    |> Column.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a column.

  ## Examples

      iex> update_column(column, %{field: new_value})
      {:ok, %Column{}}

      iex> update_column(column, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_column(%Column{} = column, attrs) do
    column
    |> Column.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a column.

  ## Examples

      iex> delete_column(column)
      {:ok, %Column{}}

      iex> delete_column(column)
      {:error, %Ecto.Changeset{}}

  """
  def delete_column(%Column{} = column) do
    Repo.delete(column)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking column changes.

  ## Examples

      iex> change_column(column)
      %Ecto.Changeset{data: %Column{}}

  """
  def change_column(%Column{} = column, attrs \\ %{}) do
    Column.changeset(column, attrs)
  end
end
