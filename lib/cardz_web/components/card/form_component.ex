defmodule CardzWeb.Components.Card.FormComponent do
  alias Cardz.Projects
  use CardzWeb, :live_component

  alias Cardz.Cards

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <.header>
          <%= @title %>
          <:subtitle>Use this form to manage project records in your database.</:subtitle>
        </.header>
        <.simple_form for={@form} id="delete-card" phx-target={@myself} phx-submit="delete_card">
          <div class="hidden">
            <.input field={@form[:id]} type="number" value={@card.id} />
          </div>
          <:actions>
            <.button value="test" data-confirm="Are you sure?" phx-disable-with="Deleting...">
              Delete
            </.button>
          </:actions>
        </.simple_form>
      </div>

      <.simple_form
        for={@form}
        id="card-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Card</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{card: card} = assigns, socket) do
    changeset = Cards.change_card(card)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"card" => card_params}, socket) do
    changeset =
      socket.assigns.card
      |> Cards.change_card(card_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"card" => card_params}, socket) do
    save_card(socket, socket.assigns.action, card_params)
  end

  @impl true
  def handle_event("delete_card", %{"card" => card_params}, socket) do
    %{"id" => id} = card_params
    card = Cards.get_card!(id)

    case Cards.delete_card(card) do
      {:ok, _card} ->
        {:noreply,
         socket
         |> put_flash(:info, "card deleted successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, _} ->
        {:noreply, socket |> put_flash(:error, "could not delete card")}
    end
  end

  defp save_card(socket, :edit_card, card_params) do
    case Cards.update_card(socket.assigns.card, card_params) do
      {:ok, _card} ->
        {:noreply,
         socket
         |> put_flash(:info, "card updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_card(socket, :new_card, card_params) do
    project = Projects.get_project!(socket.assigns.id)

    card_params
    |> Cards.create_card(socket.assigns.column_id, project.id)
    |> case do
      {:ok, _card} ->
        {:noreply,
         socket
         |> put_flash(:info, "card created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
