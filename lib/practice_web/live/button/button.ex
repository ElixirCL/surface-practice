defmodule PracticeWeb.Live.Button do
    use Surface.LiveView

    alias PracticeWeb.Live.Components.Button

    def render(assigns) do
        ~F"""
        <Button />
        """
    end
end
