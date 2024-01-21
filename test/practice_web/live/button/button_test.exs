defmodule PracticeWeb.Live.Components.ButtonTest do
  use PracticeWeb.ConnCase, async: true
  use Surface.LiveViewTest

  alias PracticeWeb.Live.Components.Button
  # alias PracticeWeb.Live.Components.ButtonSolution, as: Button

  describe "Button Component" do
    test "that renders a button" do
      html =
        render_surface do
          ~F"""
          <Button />
          """
        end

      assert html =~ "<button"
    end

    test "that allows the user to pass a button text" do
      html =
        render_surface do
          ~F"""
          <Button text="Click me" />
          """
        end

      assert html =~ "Click me</button>"
    end

    test "that allows the user to pass a click event" do
      html =
        render_surface do
          ~F"""
          <Button text="Click me" click="on:click:button" />
          """
        end

      assert html =~ "phx-click=\"on:click:button\""
    end
  end
end
