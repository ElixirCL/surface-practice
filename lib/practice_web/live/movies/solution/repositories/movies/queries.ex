defmodule Practice.Repositories.Movies.Queries do
  @endpoint "https://api.themoviedb.org/3/"
  defp token, do: Application.get_env(:practice, :movie_api_key_solution)

  def search(query) do
    Req.new(
      base_url: @endpoint,
      url: "search/movie",
      params: [
        query: query,
        include_adult: false
      ],
      auth: {:bearer, token()},
      headers: %{"content-type": "application/json"}
    )
    |> Req.get()
  end
end
