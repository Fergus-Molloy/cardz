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
     |> assign(:project, Projects.get_project!(id))
     |> assign(
       :card,
       # :card -> nil if no card_id is set, card_id will always be set when the modal is open
       # see: router.ex ~p"/projects/:id/cards/:card_id/edit"
       assigns["card_id"]
       |> case do
         nil -> nil
         card_id -> Cardz.Cards.get_card!(card_id)
       end
     )}
  end

  @impl true
  def handle_info({CardzWeb.Components.Cards.FormComponent, {:saved_card, card}}, socket) do
    {:noreply, stream_insert(socket, :cards, card)}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
  defp page_title(:edit_card), do: "Edit Card"
end
