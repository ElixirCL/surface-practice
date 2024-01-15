defmodule PracticeWeb.Live.MoviesSolution do
  use Surface.LiveView

  alias Practice.Repositories.Movies

  data search, :string, default: nil
  data results, :list, default: []
  data page_title, :string, default: "Movies"

  def handle_event("on:change:search", %{"_target" => ["search"], "search" => search}, socket) do
    {:noreply,
     socket
     |> assign(:search, search)}
  end

  def handle_event("on:click:search", _params, socket) do
      case socket.assigns.search do
          nil -> {:noreply, socket}
          query -> {:noreply,
              socket
              |> assign(:search, nil)
              |> assign(:results, Movies.search(query))}
      end
  end

  # MARK: Lifecycle
  def render(assigns) do
    ~F"""
    <div class="m-2">
      <h1 class="text-2xl font-bold mb-2">Movie Search Page</h1>
      <div class="flex">
        <form class="flex-auto mr-2" :on-change="on:change:search">
          <input
            class="appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-purple-500"
            type="text"
            name="search"
            value={@search}
            placeholder="Search: Mars Attack!"
            autofocus
          />
        </form>
        <button
          class="flex-auto ml-2 shadow bg-purple-500 hover:bg-purple-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded"
          :on-click="on:click:search"
        >Search</button>
      </div>
        <div class="mt-4 grid grid-cols-6 md:grid-cols-3 gap-4">
            {#for %{title: title, image: image, id: id} <- @results}
                <div>
                    <h2 class="text-xl">{title}</h2>
                    <img class="h-100 w-auto max-w-full rounded-lg" src={image} alt={title} />
                </div>
            {/for}
        </div>
    </div>
    """
  end
end
