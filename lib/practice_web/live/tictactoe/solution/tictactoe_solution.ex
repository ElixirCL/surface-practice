defmodule PracticeWeb.Live.TicTacToeSolution do
  use Surface.LiveView

  @moduledoc """
  An example Tic Tac Toe Game inspired by React Tutorial
  https://react.dev/learn/tutorial-tic-tac-toe
  """

  # MARK: State
  data squares, :list, default: Enum.map(0..8, fn _ -> nil end)
  data current_player, :atom, default: :x
  data status, :string, default: "Next Player: X"

  # MARK: Helper Functions

  defp gameover?(socket) do
    case get_winner(socket) do
      nil -> false
      _ -> true
    end
  end

  defp square_used?(socket, position) do
    case Enum.at(socket.assigns.squares, String.to_integer(position)) do
      nil -> false
      _ -> true
    end
  end

  defp reset(socket) do
    socket
    |> assign(:squares, Enum.map(0..8, fn _ -> nil end))
    |> assign(:current_player, :x)
    |> assign(:status, "Next Player: X")
  end

  defp get_winner(socket) do
    # Winning Positions
    squares = socket.assigns.squares

    [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ]
    |> Enum.map(fn [a, b, c] ->
      first = Enum.at(squares, a)
      second = Enum.at(squares, b)
      third = Enum.at(squares, c)

      if first == second && first == third do
        first
      else
        nil
      end
    end)
    |> Enum.filter(fn item -> item != nil end)
    |> List.first()
  end

  defp set_square(socket, position) do
    assign(
      socket,
      :squares,
      socket.assigns.squares
      |> Enum.with_index()
      |> Enum.map(fn {item, index} ->
        case index == String.to_integer(position) do
          true -> socket.assigns.current_player
          false -> item
        end
      end)
    )
  end

  defp set_current_player(socket) do
    assign(socket, :current_player, get_next_player(socket))
  end

  defp get_next_player(socket) do
    case socket.assigns.current_player do
      :x -> :o
      _ -> :x
    end
  end

  defp upcase(value) do
    value
    |> Kernel.to_string()
    |> String.upcase()
  end

  defp set_status(socket) do
    assign(
      socket,
      :status,
      case get_winner(socket) do
        nil ->
          "Next Player: #{get_next_player(socket) |> upcase()}"

        winner ->
          "Winner #{upcase(winner)}"
      end
    )
  end

  # MARK: UI Components

  # MARK: - Square Component
  attr :icon, :string, default: ""
  attr :position, :integer, default: 0

  def square(assigns) do
    ~F"""
    <style>
      .square {
        background: #fff;
        border: 1px solid #999;
        float: left;
        font-size: 24px;
        font-weight: bold;
        line-height: 34px;
        height: 34px;
        margin-right: -1px;
        margin-top: -1px;
        padding: 0;
        text-align: center;
        width: 34px;
      }
    </style>
    <button class="square" value={@position} :on-click="on:click:square">{@icon}</button>
    """
  end

  # MARK: - Board Component
  attr :squares, :list, required: true
  attr :status, :string, required: true

  def board(assigns) do
    ~F"""
    <style>
      .status {
        margin-bottom: 10px;
      }

      .board-row:after {
        clear: both;
        content: '';
        display: table;
      }
    </style>
    <div class="status font-bold">
      <p>{@status}</p>
    </div>
    <div class="board-row">
      <.square icon={Enum.at(@squares, 0)} position={0} />
      <.square icon={Enum.at(@squares, 1)} position={1} />
      <.square icon={Enum.at(@squares, 2)} position={2} />
    </div>
    <div class="board-row">
      <.square icon={Enum.at(@squares, 3)} position={3} />
      <.square icon={Enum.at(@squares, 4)} position={4} />
      <.square icon={Enum.at(@squares, 5)} position={5} />
    </div>
    <div class="board-row">
      <.square icon={Enum.at(@squares, 6)} position={6} />
      <.square icon={Enum.at(@squares, 7)} position={7} />
      <.square icon={Enum.at(@squares, 8)} position={8} />
    </div>
    """
  end

  # MARK: UI Events

  def handle_event("on:click:square", %{"value" => position}, socket) do
    if gameover?(socket) || square_used?(socket, position) do
      {:noreply, socket}
    else
      {:noreply,
       socket
       |> set_square(position)
       |> set_status()
       |> set_current_player()}
    end
  end

  def handle_event("on:click:reset", _, socket) do
    {:noreply,
     socket
     |> reset()}
  end

  # MARK: Lifecyle

  def render(assigns) do
    ~F"""
    <style>
      .game {
        display: flex;
        flex-direction: row;
      }

      .game-info {
        margin-left: 20px;
      }

      .btn-reset {
        @apply bg-white py-2 px-4 border rounded shadow;
      }
    </style>
    <div class="game">
      <div class="game-board">
        <.board squares={@squares} status={@status} />
      </div>
      <div class="game-info">
        <button class="btn-reset" :on-click="on:click:reset">Reset</button>
      </div>
    </div>
    """
  end
end
