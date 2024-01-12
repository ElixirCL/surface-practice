defmodule PracticeWeb.Live.TimerSolution do
    # MARK: Imports
    use Surface.LiveView

    # MARK: State
    @one_second_in_milliseconds 1000
    @five_minutes_in_seconds 300
    @five_minutes_string "05:00"
    @seconds_in_hour 3600
    @seconds_in_minute 60

    data current_time, :string, default: @five_minutes_string
    data timer, :reference, default: nil
    data state, :atom, default: :idle
    data seconds, :integer, default: @five_minutes_in_seconds

    # MARK: Helpers
    defp pad_number(number) when number < 10 do
      "0#{number}"
    end

    defp pad_number(number) do
        "#{number}"
    end

    defp seconds_to_string(seconds) do
      "#{
        rem(seconds, @seconds_in_hour)
        |> div(@seconds_in_minute)
        |> pad_number()
        }:#{
            rem(seconds, @seconds_in_hour)
            |> rem(@seconds_in_minute)
            |> pad_number()
        }"
    end

    # MARK: Server Events
    def handle_info(:tick, %{assigns: %{seconds: 0, state: :running}} = socket) do
        {:noreply,
            socket
            |> assign(:state, :idle)
            |> assign(:current_time, "00:00")
        }
    end

    def handle_info(:tick, %{assigns: %{seconds: seconds, state: :running}} = socket) do
        next_seconds = seconds - 1
        {:noreply,
            socket
            |> assign(:seconds, next_seconds)
            |> assign(:current_time, seconds_to_string(next_seconds))
        }
    end

    def handle_info(:tick, %{assigns: %{state: :idle}} = socket) do
      {:noreply, socket}
    end

    # MARK: UI Events
    def handle_event("on:click:start", _params, socket) do
        {:noreply,
            assign(socket, :state, :running)
        }
    end

    def handle_event("on:click:stop", _params, socket) do
        {:noreply,
            assign(socket, :state, :idle)
        }
    end

    def handle_event("on:click:reset", _params, socket) do
        {:noreply,
            socket
            |> assign(:state, :idle)
            |> assign(:seconds, @five_minutes_in_seconds)
            |> assign(:current_time, @five_minutes_string)
        }
    end

    # MARK: Lifecycle

    def mount(_params, _session, socket) do
        {:ok, assign(socket, :timer, :timer.send_interval(@one_second_in_milliseconds, self(), :tick))}
    end

    def render(assigns) do
        ~F"""
            <h1 class="font-bold text-5xl p-3">{@current_time}</h1>
            <button class="bg-white py-2 px-4 border rounded shadow" :on-click="on:click:start">Iniciar</button>
            <button class="bg-white py-2 px-4 border rounded shadow" :on-click="on:click:stop">Pausar</button>
            <button class="bg-white py-2 px-4 border rounded shadow" :on-click="on:click:reset">Resetear</button>
        """
    end
end
