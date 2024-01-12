defmodule PracticeWeb.Live.Components.ButtonSolution do
    use Surface.Component

    prop text, :string, default: ""
    prop click, :event, default: ""

    def render(assigns) do
        ~F"""
        <style>
            .btn {
                @apply bg-white py-2 px-4 border rounded shadow;
            }
        </style>
        <button class="btn" :on-click={@click}>{@text}</button>
        """
    end
end
