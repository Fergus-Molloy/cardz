defmodule CardzWeb.ProjectLive.Show do
  use CardzWeb, :live_view

  alias Cardz.Projects

  def show_card_modal(:edit_card), do: true
  def show_card_modal(:new_card), do: true
  def show_card_modal(_), do: false

  def show_column_modal(:edit_column), do: true
  def show_column_modal(:new_column), do: true
  def show_column_modal(_), do: false

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:project, Projects.get_project!(id))
     |> stream(:columns, Cardz.Columns.list_columns_for_project(id, :preload))
     |> stream(:cards, Cardz.Cards.list_cards_for_project(id))}
  end

  @impl true
  def handle_params(assigns, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       :column,
       assigns["column_id"]
       |> case do
         # new col
         nil -> %Cardz.Columns.Column{}
         # edit col
         col_id -> Cardz.Columns.get_column!(col_id)
       end
     )
     |> assign(
       :card,
       assigns["card_id"]
       |> case do
         # new card
         nil -> %Cardz.Cards.Card{}
         # edit card
         card_id -> Cardz.Cards.get_card!(card_id)
       end
     )}
  end

  @impl true
  def handle_info({CardzWeb.Components.Projects.FormComponent, {:saved, project}}, socket) do
    {:noreply, assign(socket, :project, project)}
  end

  @impl true
  def handle_info({CardzWeb.Components.Cards.FormComponent, {:saved_card, card}}, socket) do
    {:noreply, stream_insert(socket, :cards, card)}
  end

  @impl true
  def handle_info({CardzWeb.Components.Columns.FormComponent, {:saved_col, col}}, socket) do
    {:noreply, stream_insert(socket, :columns, col)}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
  defp page_title(:edit_card), do: "Edit Card"
  defp page_title(:new_card), do: "New Card"
  defp page_title(:edit_column), do: "Edit Column"
  defp page_title(:new_column), do: "New Column"
end
