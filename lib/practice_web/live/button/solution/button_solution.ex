defmodule PracticeWeb.Live.ButtonSolution do
    use Surface.LiveView

    alias PracticeWeb.Live.Components.ButtonSolution, as: Button

    def handle_event("on:click:button", _params, socket) do
      IO.inspect "Button Clicked"
      {:noreply, socket}
    end

    def render(assigns) do
        ~F"""
        <Button text="Click Me" click="on:click:button" />
        """
    end
end
