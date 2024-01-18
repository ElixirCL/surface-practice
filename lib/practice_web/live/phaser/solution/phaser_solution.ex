defmodule PracticeWeb.Live.PhaserSolution do
    use Surface.LiveView

    def mount(_params, _session, socket) do
        socket = socket
        |> push_event("on:mount", %{hello: :from_surface})

        {:ok, socket}
    end

    def render(assigns) do
     ~F"""
     <div id="game" :hook></div>
     """
    end
 end
