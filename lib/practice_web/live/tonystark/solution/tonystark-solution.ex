defmodule PracticeWeb.Live.IronManSolution do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    socket = assign(socket, :estado, "Genio Millonario")
    {:ok, socket}
  end

  def handle_event("transformar", _params, socket) do
    {:noreply, assign(socket, :estado, "Héroe Tecnológico")}
  end

  def render(assigns) do
    ~H"""
    <p>Tony Stark está en el estado: <%= @estado %></p>

    <button phx-click="transformar">¡Transformarse!</button>
    """
  end
end
