defmodule CardzWeb.ProjectLive.ColumnFormComponent do
  alias Cardz.Projects
  use CardzWeb, :live_component

  alias Cardz.Columns

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="column-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Column</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{column: column} = assigns, socket) do
    changeset = Columns.change_column(column)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"column" => column_params}, socket) do
    changeset =
      socket.assigns.column
      |> Columns.change_column(column_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"column" => column_params}, socket) do
    IO.puts(socket.assigns.id)

    save_column(socket, socket.assigns.action, %{
      column: column_params,
      project_id: socket.assigns.id
    })
  end

  defp save_column(socket, :edit, column_params) do
    case Columns.update_column(socket.assigns.column, column_params) do
      {:ok, column} ->
        notify_parent({:saved, column})

        {:noreply,
         socket
         |> put_flash(:info, "column updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_column(socket, :new_column, %{
         :project_id => project_id,
         :column => column_params
       }) do
    IO.puts(project_id)

    project = Projects.get_project!(project_id)

    column_params
    |> Columns.create_column(project_id)
    |> case do
      {:ok, column} ->
        notify_parent(
          {:saved, %{project | columns: [column | project.columns] |> Enum.reverse()}}
        )

        {:noreply,
         socket
         |> put_flash(:info, "column created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
