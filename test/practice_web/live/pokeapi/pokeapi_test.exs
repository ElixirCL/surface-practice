defmodule PracticeWeb.Live.PokeAPITest do
  @moduledoc false
  use PracticeWeb.ConnCase, async: true
  use Surface.LiveViewTest
  import Phoenix.LiveViewTest

  @liveview_pokeapi "/pokeapi" # /pokeapi-solution

  describe "Pokemon list with 'Load more' button" do
    test "that displays the first 5 pokemons", %{conn: conn} do
      {:ok, liveview, html} = live(conn, @liveview_pokeapi)

      # first check if we have the container element
      assert liveview
             |> element("#pokemons")
             |> has_element?() == true

      # then we use Floki to parse the html
      {:ok, document} = Floki.parse_document(html)

      pokemons =
        Floki.find(document, ".pokemon")
        |> Enum.map(fn {_tag, _attributes, [pokemon]} -> pokemon end)

      # now we test our pokemon list
      assert Enum.count(pokemons) == 5
      assert pokemons == ["bulbasaur", "ivysaur", "venusaur", "charmander", "charmeleon"]
    end

    test "that shows a 'Load more' button and the info of the number of items displayed", %{
      conn: conn
    } do
      {:ok, liveview, _html} = live(conn, @liveview_pokeapi)

      button =
        liveview
        |> element("#btn-pokemon-load-more")

      assert has_element?(button) == true

      display =
        liveview
        |> element("#display-pokemon-result")

      assert has_element?(display) == true

      element_count =
        liveview
        |> element("#display-pokemon-result-count")

      assert has_element?(element_count) == true

      {:ok, [{_tag, _attrs, [count]}]} = Floki.parse_document(render(element_count))

      assert count == "5"

      element_total =
        liveview
        |> element("#display-pokemon-result-total")

      assert has_element?(element_total) == true

      {:ok, [{_tag, _attrs, [total]}]} = Floki.parse_document(render(element_total))

      # This value is from the mock server count
      # Maybe we can have it as a public function to obtain this value?
      assert total == "1281"
    end

    test "that loads 5 more pokemon when the user presses 'Load more'", %{conn: conn} do
      {:ok, liveview, _html} = live(conn, @liveview_pokeapi)

      {:ok, document} =
        liveview
        |> element("#btn-pokemon-load-more")
        |> render_click()
        |> Floki.parse_document()

      pokemons =
        Floki.find(document, ".pokemon")
        |> Enum.map(fn {_tag, _attributes, [pokemon]} -> pokemon end)

      assert Enum.count(pokemons) == 10

      assert pokemons == [
               "bulbasaur",
               "ivysaur",
               "venusaur",
               "charmander",
               "charmeleon",
               "charizard",
               "squirtle",
               "wartortle",
               "blastoise",
               "caterpie"
             ]

      # Also check the display
      {:ok, [{_tag, _attrs, [count]}]} =
        liveview
        |> element("#display-pokemon-result-count")
        |> render()
        |> Floki.parse_document()

      assert count == "10"
    end

    test "no longer shows the 'Load more' if the user reached the last page", %{conn: conn} do
      {:ok, liveview, _html} = live(conn, @liveview_pokeapi)

      button =
        liveview
        |> element("#btn-pokemon-load-more")

      # In the mock server we fetch all pokemons just by 2 clicks
      render_click(button)

      # Save the last click output to parse it
      pokemon_list = render_click(button)

      # button must not be visible if we fetched all pokemon
      assert has_element?(button) == false

      {:ok, document} =
        pokemon_list
        |> Floki.parse_document()

      pokemons =
        Floki.find(document, ".pokemon")
        |> Enum.map(fn {_tag, _attributes, [pokemon]} -> pokemon end)

      assert Enum.count(pokemons) == 12

      assert pokemons == [
               "bulbasaur",
               "ivysaur",
               "venusaur",
               "charmander",
               "charmeleon",
               "charizard",
               "squirtle",
               "wartortle",
               "blastoise",
               "caterpie",
               "metapod",
               "butterfree"
             ]

      # Also check the display
      {:ok, [{_tag, _attrs, [count]}]} =
        liveview
        |> element("#display-pokemon-result-count")
        |> render()
        |> Floki.parse_document()

      assert count == "12"
    end
  end
end
