defmodule CardzWeb.ProjectLive.Show do
  use CardzWeb, :live_view

  alias Cardz.Projects

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:project, Projects.get_project!(id))
     |> stream(:cards, Cardz.Projects.get_cards_for_project(id))}
  end

  @impl true
  def handle_params(%{"id" => id} = assigns, _, socket) do
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

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
  defp page_title(:edit_card), do: "Edit Card"
end
