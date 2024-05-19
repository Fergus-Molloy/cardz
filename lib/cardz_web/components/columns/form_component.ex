defmodule CardzWeb.Components.Columns.FormComponent do
  use CardzWeb, :live_component

  alias Cardz.Columns

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage column records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="column-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Card</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{col: col} = assigns, socket) do
    changeset = Columns.change_column(col)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"col" => col_params}, socket) do
    changeset =
      socket.assigns.col
      |> Columns.change_column(col_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"col" => col_params}, socket) do
    save_col(socket, socket.assigns.action, col_params)
  end

  defp save_col(socket, :edit_col, col_params) do
    Columns.update_column(socket.assigns.col, col_params)
    |> case do
      {:ok, col} ->
        notify_parent({:saved_col, col})

        {:noreply,
         socket
         |> put_flash(:info, "Column updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_col(socket, :new_col, col_params) do
    case Columns.create_column(col_params) do
      {:ok, col} ->
        notify_parent({:saved_col, col})

        {:noreply,
         socket
         |> put_flash(:info, "Column created successfully")
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
