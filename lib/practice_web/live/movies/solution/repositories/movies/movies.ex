defmodule Practice.Repositories.Movies do
  alias __MODULE__.Queries
  alias __MODULE__.Structs

  def search(nil), do: []

  def search(query),
    do:
      query
      |> Queries.search()
      |> Structs.search_result()
end
