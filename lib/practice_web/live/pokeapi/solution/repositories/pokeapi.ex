defmodule Practice.Repositories.PokeAPI do
  alias __MODULE__.Queries
  alias __MODULE__.Structs

  def pokemons(), do: pokemons(%{offset: "0", limit: "5"})

  def pokemons(query),
    do:
      Queries.pokemon(query)
      |> Structs.pokemon_query_result()
end
