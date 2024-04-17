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

%{:id => project_id} =
  Cardz.Repo.insert!(%Cardz.Projects.Project{
    title: "Cardz",
    description: "Demo project",
    abbr: "cdz"
  })

%{:id => todo_id} =
  Cardz.Repo.insert!(%Cardz.Columns.Column{
    title: "Todo",
    project_id: project_id
  })

%{:id => in_progress_id} =
  Cardz.Repo.insert!(%Cardz.Columns.Column{
    title: "In Progress",
    project_id: project_id
  })

%{:id => done_id} =
  Cardz.Repo.insert!(%Cardz.Columns.Column{
    title: "Done",
    project_id: project_id
  })

Cardz.Repo.insert!(%Cardz.Cards.Card{title: "Setup cardz", column_id: done_id, position: 1})

Cardz.Repo.insert!(%Cardz.Cards.Card{
  title: "Explore cardz app",
  column_id: in_progress_id,
  position: 1
})

Cardz.Repo.insert!(%Cardz.Cards.Card{title: "Create a new card", column_id: todo_id, position: 1})

Cardz.Repo.insert!(%Cardz.Cards.Card{
  title: "Create a new column",
  column_id: todo_id,
  position: 2
})
