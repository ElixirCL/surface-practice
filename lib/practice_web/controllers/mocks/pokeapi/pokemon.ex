defmodule PracticeWeb.Mocks.PokeAPI.Pokemon do
  use PracticeWeb, :controller

  @base_url Application.compile_env(
              :practice,
              :pokeapi_base_url,
              "https://pokeapi.co/api/v2/pokemon"
            )

  def index(conn, %{"limit" => "5", "offset" => "0"}) do
    json(
      conn,
      Jason.decode!("""
      {
        "count": 1281,
        "next": "#{@base_url}?offset=5&limit=5",
        "previous": null,
        "results": [
          {
            "name": "bulbasaur",
            "url": "#{@base_url}/1/"
          },
          {
            "name": "ivysaur",
            "url": "#{@base_url}/2/"
          },
          {
            "name": "venusaur",
            "url": "#{@base_url}/3/"
          },
          {
            "name": "charmander",
            "url": "#{@base_url}/4/"
          },
          {
            "name": "charmeleon",
            "url": "#{@base_url}/5/"
          }
        ]
      }
      """)
    )
  end

  def index(conn, %{"limit" => "5", "offset" => "5"}) do
    json(
      conn,
      Jason.decode!("""
      {
          "count": 1281,
          "next": "#{@base_url}?offset=10&limit=5",
          "previous": "#{@base_url}?offset=0&limit=5",
          "results": [
            {
              "name": "charizard",
              "url": "#{@base_url}/6/"
            },
            {
              "name": "squirtle",
              "url": "#{@base_url}/7/"
            },
            {
              "name": "wartortle",
              "url": "#{@base_url}/8/"
            },
            {
              "name": "blastoise",
              "url": "#{@base_url}/9/"
            },
            {
              "name": "caterpie",
              "url": "#{@base_url}/10/"
            }
          ]
        }
      """)
    )
  end

  def index(conn, %{"limit" => "5", "offset" => "10"}) do
    json(
      conn,
      Jason.decode!("""
      {
          "count": 12,
          "next": null,
          "previous": "#{@base_url}?offset=5&limit=5",
          "results": [
            {
              "name": "metapod",
              "url": "#{@base_url}/11/"
            },
            {
              "name": "butterfree",
              "url": "#{@base_url}/12/"
            }
          ]
        }
      """)
    )
  end

  def index(conn, _params) do
    json(conn, %{count: 0, results: []})
  end
end
