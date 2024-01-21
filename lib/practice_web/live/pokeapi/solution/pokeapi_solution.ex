defmodule PracticeWeb.Live.PokeAPISolution do
  use Surface.LiveView

  alias Practice.Repositories.PokeAPI

  @offset 0
  @limit 5

  data page_title, :string, default: "PokeAPI"

  data offset, :integer, default: @offset
  data limit, :integer, default: @limit
  data response, :map, default: %{}
  data pokemons, :list, default: []

  def mount(_params, _session, socket) do
    response = PokeAPI.pokemons()

    socket =
      socket
      |> assign(:response, response)
      |> assign(:pokemons, response.results)

    {:ok, socket}
  end

  def handle_event("on:click:load:more", _params, socket) do
    response = PokeAPI.pokemons(socket.assigns.response.next.query)
    pokemons = socket.assigns.pokemons ++ response.results

    socket =
      socket
      |> assign(:response, response)
      |> assign(:pokemons, pokemons)

    {:noreply, socket}
  end

  def render(assigns) do
    ~F"""
    <div class="mt-5 ml-10">
      <span class="mb-2" id="display-pokemon-result">Displaying <span id="display-pokemon-result-count">{Enum.count(@pokemons)}</span> of <span id="display-pokemon-result-total">{@response.count}</span> results.</span>

      <ul id="pokemons">
        {#for pokemon <- @pokemons}
          <li class="pokemon" id={"pokemon-#{pokemon.id}"}>{pokemon.name}</li>
        {/for}
      </ul>

      {#if @response.next.query}
        <button
          id="btn-pokemon-load-more"
          class="mt-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          :on-click="on:click:load:more"
        >Load More</button>
      {/if}
    </div>
    """
  end
end
