defmodule CardzWeb.ProjectLive.Show do
  use CardzWeb, :live_view

  alias Cardz.Projects

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, stream(socket, :cards, Cardz.Projects.get_cards(id) |> IO.inspect())}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, Projects.get_project!(id))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
