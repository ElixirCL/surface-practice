defmodule PracticeWeb.Live.TodoSolution do
  use Surface.LiveView

  # MARK: State Props
  data todo, :string, default: nil
  data todos, :map, default: []
  data page_title, :string, default: "TODO List"

  # MARK: Helper Modules
  def todo_to_string(%{todo: todo, index: _index, checked: _checked}), do: todo
  def todo_to_string(_), do: ""

  # MARK: UI Events
  def handle_event("on:write:todo", %{"_target" => ["todo"], "todo" => todo}, socket) do
    count = Enum.count(socket.assigns.todos)

    unique_index =
      :os.system_time(:millisecond) + count + :rand.uniform(count + 100_000) + String.length(todo)

    item = %{todo: todo, index: unique_index, checked: false}
    {:noreply, assign(socket, :todo, item)}
  end

  def handle_event(
        "on:check:todos",
        %{"_target" => [index]} = params,
        socket
      ) do
    status = Map.get(params, index)
    item_index = String.to_integer(index)

    todos =
      Enum.map(socket.assigns.todos, fn
        %{todo: todo, index: todo_index, checked: _checked} = item ->
          case status do
            "check" ->
              if item_index == todo_index do
                %{todo: todo, index: todo_index, checked: true}
              else
                item
              end

            "uncheck" ->
              if item_index == todo_index do
                %{todo: todo, index: todo_index, checked: false}
              else
                item
              end
          end
      end)

    {:noreply,
     assign(socket, :todos, todos)
     # Send update event to JS Hook
     |> push_event("update:todos", %{todos: todos})}
  end

  def handle_event("on:click:add", _params, socket) do
    case socket.assigns.todo do
      nil ->
        {:noreply, socket}

      todo ->
        todos = [todo | socket.assigns.todos]

        {:noreply,
         socket
         |> assign(:todos, todos)
         |> assign(:todo, nil)
         |> push_event("update:todos", %{todos: todos})}
    end
  end

  # MARK: Javascript Hook Events
  def handle_event("on:local:storage:mount", nil, socket), do: {:noreply, socket}

  def handle_event("on:local:storage:mount", todos_string, socket) do
    todos =
      Enum.map(Jason.decode!(todos_string), fn %{
                                                 "todo" => todo,
                                                 "index" => index,
                                                 "checked" => checked
                                               } ->
        %{todo: todo, index: index, checked: checked}
      end)

    {:noreply,
     socket
     |> assign(:todos, todos)}
  end

  # MARK: Lifecycle

  def render(assigns) do
    ~F"""
    <div id="todos" class="m-4" :hook>
      <h1 class="font-bold text-xl">Todo List App</h1>
      <div class="flex">
        <form class="flex-auto w-full max-w-sm mr-2 mt-2" :on-change="on:write:todo">
          <input
            class="appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-purple-500"
            name="todo"
            type="text"
            placeholder="Add a new todo"
            value={todo_to_string(@todo)}
            autofocus
          />
        </form>

        <button
          class="mt-2 shadow bg-purple-500 hover:bg-purple-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded"
          :on-click="on:click:add"
        >Add</button>
      </div>
      <div class="mt-2">
        <ul>
          <form :on-change="on:check:todos">
            <span class="text-lg">Total Todos: {Enum.count(@todos)}</span>
            {#for %{todo: todo, index: index, checked: checked} <- @todos}
              <li>
                {!-- This is a simple trick to always send the check status. Put a hidden input with the unchecked value --}
                <input type="hidden" value="uncheck" name={index}>
                <input class="p-3 m-3" value="check" type="checkbox" name={index} checked={checked}>{todo}
              </li>
            {/for}
          </form>
        </ul>
      </div>
    </div>
    """
  end
end
