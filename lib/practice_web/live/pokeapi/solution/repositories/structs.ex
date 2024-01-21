defmodule Practice.Repositories.PokeAPI.Structs do
  require Logger

  @base_url Application.compile_env(
              :practice,
              :pokeapi_base_url,
              "https://pokeapi.co/api/v2"
            )

  defp get_query_from_url(url) when is_binary(url) do
    uri = URI.parse(url)

    case uri.query do
      nil ->
        nil

      query ->
        URI.query_decoder(query)
        |> Enum.to_list()
        |> Enum.map(fn {key, value} -> %{"#{key}": value} end)
        |> Enum.reduce(%{}, fn item, acc -> Map.merge(acc, item) end)
    end
  end

  defp get_query_from_url(_), do: nil

  defp get_id_from_url(url) when is_binary(url) do
    uri =
      url
      |> String.replace(@base_url <> "/pokemon", "")
      |> URI.parse()

    uri.path
    |> String.split("/")
    |> Enum.filter(fn item -> item != "" && item != nil end)
    |> List.first()
  end

  def pokemon_query_result({:ok, %Req.Response{} = result}) do
    body = result.body

    %{
      count: get_in(body, ["count"]),
      next: %{
        url: get_in(body, ["next"]),
        query: get_query_from_url(get_in(body, ["next"]))
      },
      prev: %{
        url: get_in(body, ["previous"]),
        query: get_query_from_url(get_in(body, ["previous"]))
      },
      results:
        Enum.map(get_in(body, ["results"]), fn item ->
          %{
            id: get_id_from_url(get_in(item, ["url"])),
            name: get_in(item, ["name"]),
            url: get_in(item, ["url"]),
            query: get_query_from_url(get_in(item, ["url"]))
          }
        end)
    }
  end

  def pokemon_query_result({:error, message}) do
    Logger.error(message)
    []
  end

  def pokemon_query_result(any), do: any
end
