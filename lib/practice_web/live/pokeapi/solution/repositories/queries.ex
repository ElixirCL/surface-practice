defmodule Practice.Repositories.PokeAPI.Queries do
  @base_url Application.compile_env(
              :practice,
              :pokeapi_base_url,
              "https://pokeapi.co/api/v2"
            )

  def pokemon(query) do
    Req.new(
      base_url: @base_url,
      url: "pokemon",
      params: query,
      headers: %{"content-type": "application/json"}
    )
    |> Req.get()
  end
end
