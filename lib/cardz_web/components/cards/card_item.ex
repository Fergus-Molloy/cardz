defmodule CardzWeb.Components.Cards do
  use Phoenix.Component

  attr :card, :any, required: true

  def card_item(assigns) do
    ~H"""
    <%= @card.title %>
    """
  end
end
