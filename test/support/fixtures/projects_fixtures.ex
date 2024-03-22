defmodule Cardz.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cardz.Projects` context.
  """

  @doc """
  Generate a unique project abbr.
  """
  def unique_project_abbr, do: "some abbr#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique project title.
  """
  def unique_project_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        abbr: unique_project_abbr(),
        description: "some description",
        title: unique_project_title()
      })
      |> Cardz.Projects.create_project()

    project
  end
end
