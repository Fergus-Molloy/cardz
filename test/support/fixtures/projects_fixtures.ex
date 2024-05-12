defmodule Cardz.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cardz.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Cardz.Projects.create_project()

    project
  end
end
