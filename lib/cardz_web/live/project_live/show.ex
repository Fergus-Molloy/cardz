defmodule CardzWeb.ProjectLive.Show do
  use CardzWeb, :live_view

  alias Cardz.Projects

  def show_card_modal(:edit_card), do: true
  def show_card_modal(:new_card), do: true
  def show_card_modal(_), do: false

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
  defp page_title(:edit_col), do: "Edit Column"
  defp page_title(:new_col), do: "New Column"
end
