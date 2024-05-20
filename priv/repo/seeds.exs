# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cardz.Repo.insert!(%Cardz.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

project =
  Cardz.Repo.insert!(%Cardz.Projects.Project{
    title: "Example Project",
    description: "a starter project"
  })

col_todo =
  Cardz.Repo.insert!(%Cardz.Columns.Column{
    title: "Todo",
    description: "Tasks still to do",
    project_id: project.id
  })

col_in_progress =
  Cardz.Repo.insert!(%Cardz.Columns.Column{
    title: "In Progress",
    description: "Currently being worked on",
    project_id: project.id
  })

col_done =
  Cardz.Repo.insert!(%Cardz.Columns.Column{
    title: "Done",
    description: "Completed tasks",
    project_id: project.id
  })

Cardz.Repo.insert!(%Cardz.Cards.Card{
  title: "Add new card",
  description: "add a new card to a column",
  column_id: col_todo.id,
  priority: 1
})

Cardz.Repo.insert!(%Cardz.Cards.Card{
  title: "Add new column",
  description: "add a new column to a project",
  column_id: col_todo.id,
  priority: 2
})

Cardz.Repo.insert!(%Cardz.Cards.Card{
  title: "Explore the cardz app",
  description: "take a look at the feature available",
  column_id: col_in_progress.id,
  priority: 1
})

Cardz.Repo.insert!(%Cardz.Cards.Card{
  title: "Successfully run the cardz app",
  description: "get the app up and running and seed it with example data",
  column_id: col_done.id,
  priority: 1
})
