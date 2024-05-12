defmodule Cardz.ColumnsTest do
  use Cardz.DataCase

  alias Cardz.Columns

  describe "columns" do
    alias Cardz.Columns.Column

    import Cardz.ColumnsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_columns/0 returns all columns" do
      column = column_fixture()
      assert Columns.list_columns() == [column]
    end

    test "get_column!/1 returns the column with given id" do
      column = column_fixture()
      assert Columns.get_column!(column.id) == column
    end

    test "create_column/1 with valid data creates a column" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Column{} = column} = Columns.create_column(valid_attrs)
      assert column.description == "some description"
      assert column.title == "some title"
    end

    test "create_column/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Columns.create_column(@invalid_attrs)
    end

    test "update_column/2 with valid data updates the column" do
      column = column_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Column{} = column} = Columns.update_column(column, update_attrs)
      assert column.description == "some updated description"
      assert column.title == "some updated title"
    end

    test "update_column/2 with invalid data returns error changeset" do
      column = column_fixture()
      assert {:error, %Ecto.Changeset{}} = Columns.update_column(column, @invalid_attrs)
      assert column == Columns.get_column!(column.id)
    end

    test "delete_column/1 deletes the column" do
      column = column_fixture()
      assert {:ok, %Column{}} = Columns.delete_column(column)
      assert_raise Ecto.NoResultsError, fn -> Columns.get_column!(column.id) end
    end

    test "change_column/1 returns a column changeset" do
      column = column_fixture()
      assert %Ecto.Changeset{} = Columns.change_column(column)
    end
  end
end
