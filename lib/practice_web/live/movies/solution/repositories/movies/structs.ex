defmodule Practice.Repositories.Movies.Structs do
  require Logger

  def search_result({:ok, %Req.Response{} = result}) do
    Enum.map(get_in(result.body, ["results"]), fn item ->
      %{
        id: get_in(item, ["id"]),
        title: get_in(item, ["original_title"]),
        image:
          case get_in(item, ["poster_path"]) do
            nil -> "https://place-hold.it/500x773"
            path -> "https://image.tmdb.org/t/p/w500/#{path}"
          end
      }
    end)
  end

  def search_result({:error, message}) do
    Logger.error(message)
    []
  end

  def search_result(any), do: any
end
