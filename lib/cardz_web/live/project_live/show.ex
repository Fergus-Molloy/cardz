defmodule CardzWeb.ProjectLive.Show do
  use CardzWeb, :live_view

  alias Cardz.Projects
  alias Cardz.Columns
  alias Cardz.Cards

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:project, Projects.get_project!(id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:project, Projects.get_project!(id))
  end

  defp apply_action(socket, :new_column, %{"id" => project_id}) do
    socket
    |> assign(:page_title, "New Column")
    |> assign(:column, %Columns.Column{project_id: project_id})
    |> assign(:project, Projects.get_project!(project_id))
  end

  defp apply_action(socket, :edit_column, %{"id" => project_id, "column_id" => column_id}) do
    socket
    |> assign(:page_title, "Edit Column")
    |> assign(:column, Columns.get_column!(column_id))
    |> assign(:project, Projects.get_project!(project_id))
  end

  defp apply_action(socket, :new_card, %{"id" => project_id, "column_id" => column_id}) do
    socket
    |> assign(:column_id, column_id)
    |> assign(:page_title, "New Card")
    |> assign(:card, %Cards.Card{})
    |> assign(:project, Projects.get_project!(project_id))
  end

  defp apply_action(socket, :edit_card, %{"id" => project_id, "card_id" => card_id}) do
    socket
    |> assign(:page_title, "Edit Card")
    |> assign(:card, Cards.get_card!(card_id))
    |> assign(:project, Projects.get_project!(project_id))
  end

  @impl true
  def handle_info({CardzWeb.Components.Project.FormComponent, {:saved, _}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({CardzWeb.Components.Column.FormComponent, {:saved_column, _}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({CardzWeb.Components.Card.FormComponent, {:saved_card, _}}, socket) do
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
