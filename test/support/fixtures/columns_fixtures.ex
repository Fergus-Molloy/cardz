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
        title: "some title"
      })
      |> Cardz.Columns.create_column()

    column
  end
end
