defmodule Cardz.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias Cardz.Repo

  alias Cardz.Cards.Card

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
  end

  def list_cards_for_project(id) do
    query =
      from card in Cardz.Cards.Card,
        left_join: col in assoc(card, :column),
        where: col.project_id == ^id,
        order_by: [card.column_id, card.priority],
        preload: :column

    Repo.all(query)
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id) |> Repo.preload(:column)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, card} -> {:ok, get_card!(card.id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
    |> case do
      # get card will load normal preloads
      {:ok, card} -> {:ok, get_card!(card.id)}
      {:eror, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end

  def group_by_col(cards) do
    cards
    |> Enum.reduce(
      %{},
      fn card, acc ->
        if Map.has_key?(acc, card.column_id) do
          Map.put(acc, card.column_id, [card | acc.column_id])
        else
          Map.put(acc, card.column_id, [card])
        end
      end
    )
  end
end
