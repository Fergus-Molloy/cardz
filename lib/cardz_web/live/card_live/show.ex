defmodule CardzWeb.CardLive.Show do
  use CardzWeb, :live_view

  alias Cardz.Cards

  @impl true
  def mount(%{"project_id" => project_id, "card_id" => card_id}, _session, socket) do
    {:ok,
     socket
     |> assign(:project_id, project_id)
     |> assign(:card, Cards.get_card!(card_id))}
  end

  @impl true
  def handle_params(_assigns, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  @impl true
  def handle_info({CardzWeb.Components.Cards.FormComponent, {:saved_card, card}}, socket) do
    {:noreply, stream_insert(socket, :cards, card)}
  end

  defp page_title(:show), do: "Show Card"
  defp page_title(:edit), do: "Edit Card"
end
