defmodule CardzWeb.Components.Column.FormComponent do
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

      <.simple_form for={@form} id="delete-column" phx-target={@myself} phx-submit="delete_column">
        <div class="hidden">
          <.input field={@form[:id]} type="number" value={@column.id} />
        </div>
        <:actions>
          <.button value="test" data-confirm="Are you sure?" phx-disable-with="Deleting...">
            Delete
          </.button>
        </:actions>
      </.simple_form>

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

  @impl true
  def handle_event("delete_column", %{"column" => column_params}, socket) do
    %{"id" => id} = column_params
    column = Columns.get_column!(id)

    case Columns.delete_column(column) do
      {:ok, _column} ->
        {:noreply,
         socket
         |> put_flash(:info, "column deleted successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "could not delete column")}
    end
  end

  def handle_event("save", %{"column" => column_params}, socket) do
    save_column(socket, socket.assigns.action, column_params)
  end

  defp save_column(socket, :edit_column, column_params) do
    case Columns.update_column(socket.assigns.column, column_params) do
      {:ok, _} ->
        notify_parent({:saved_column, Projects.get_project!(socket.assigns.id)})

        {:noreply,
         socket
         |> put_flash(:info, "column updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_column(socket, :new_column, column_params) do
    project = Projects.get_project!(socket.assigns.id)

    column_params
    |> Columns.create_column(project.id)
    |> case do
      {:ok, _} ->
        notify_parent({:saved_column, project})

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
