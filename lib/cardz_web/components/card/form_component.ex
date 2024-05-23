defmodule CardzWeb.Components.Cards.FormComponent do
  use CardzWeb, :live_component

  alias Cardz.Cards

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :columns, Cardz.Columns.list_columns_for_project(assigns.id))

    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage card records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="card-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
          field={@form[:column_id]}
          type="select"
          label="Status"
          options={status_opts(@columns)}
        />
        <.input field={@form[:priority]} type="number" label="Priority" min="0" max={@max_priority} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Card</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp status_opts(columns) do
    for status <- columns,
        do: [key: status.title, value: status.id]
  end

  @impl true
  def update(%{card: card, id: project_id} = assigns, socket) do
    changeset = Cards.change_card(card)

    get_card_count =
      fn %{id: id} -> Cardz.Columns.count_cards(id) end

    s =
      if card != nil && card.column_id != nil do
        socket
        |> assign(assigns)
        |> assign_form(changeset)
        |> assign(:max_priority, Cardz.Columns.count_cards(card.column_id) + 1)
      else
        socket
        |> assign(assigns)
        |> assign_form(changeset)
        |> assign(
          :max_priority,
          Cardz.Columns.get_first_column(project_id)
          |> get_card_count.()
        )
      end

    {:ok, s}
  end

  @impl true
  def handle_event("validate", %{"card" => card_params}, socket) do
    changeset =
      socket.assigns.card
      |> Cards.change_card(card_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign_form(changeset)}
  end

  def handle_event("save", %{"card" => card_params}, socket) do
    save_card(socket, socket.assigns.action, card_params)
  end

  defp save_card(socket, :edit_card, card_params) do
    Cards.update_card(socket.assigns.card, card_params)
    |> case do
      {:ok, card} ->
        notify_parent({:saved_card, card})

        {:noreply,
         socket
         |> put_flash(:info, "Card updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_card(socket, :new_card, card_params) do
    case Cards.create_card(card_params) do
      {:ok, card} ->
        notify_parent({:saved_card, card})

        {:noreply,
         socket
         |> put_flash(:info, "Card created successfully")
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
