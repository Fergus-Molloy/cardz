defmodule Cardz.ColumnsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cardz.Columns` context.
  """

  @doc """
  Generate a column.
  """
  def column_fixture(attrs \\ %{}) do
    {:ok, column} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Cardz.Columns.create_column()

    column
  end
end
