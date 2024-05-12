defmodule Cardz.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cardz.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Cardz.Cards.create_card()

    card
  end
end
