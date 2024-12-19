defmodule ExListeningWeb.ListeningTestLiveTest do
  use ExListeningWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExListening.ListeningTestsFixtures

  @create_attrs %{path: "some path", description: "some description"}
  @update_attrs %{path: "some updated path", description: "some updated description"}
  @invalid_attrs %{path: nil, description: nil}

  defp create_listening_test(_) do
    listening_test = listening_test_fixture()
    %{listening_test: listening_test}
  end

  describe "Index" do
    setup [:create_listening_test]

    test "lists all tests", %{conn: conn, listening_test: listening_test} do
      {:ok, _index_live, html} = live(conn, ~p"/tests")

      assert html =~ "Listing Tests"
      assert html =~ listening_test.path
    end

    test "saves new listening_test", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tests")

      assert index_live |> element("a", "New Listening test") |> render_click() =~
               "New Listening test"

      assert_patch(index_live, ~p"/tests/new")

      assert index_live
             |> form("#listening_test-form", listening_test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#listening_test-form", listening_test: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tests")

      html = render(index_live)
      assert html =~ "Listening test created successfully"
      assert html =~ "some path"
    end

    test "updates listening_test in listing", %{conn: conn, listening_test: listening_test} do
      {:ok, index_live, _html} = live(conn, ~p"/tests")

      assert index_live |> element("#tests-#{listening_test.id} a", "Edit") |> render_click() =~
               "Edit Listening test"

      assert_patch(index_live, ~p"/tests/#{listening_test}/edit")

      assert index_live
             |> form("#listening_test-form", listening_test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#listening_test-form", listening_test: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tests")

      html = render(index_live)
      assert html =~ "Listening test updated successfully"
      assert html =~ "some updated path"
    end

    test "deletes listening_test in listing", %{conn: conn, listening_test: listening_test} do
      {:ok, index_live, _html} = live(conn, ~p"/tests")

      assert index_live |> element("#tests-#{listening_test.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tests-#{listening_test.id}")
    end
  end

  describe "Show" do
    setup [:create_listening_test]

    test "displays listening_test", %{conn: conn, listening_test: listening_test} do
      {:ok, _show_live, html} = live(conn, ~p"/tests/#{listening_test}")

      assert html =~ "Show Listening test"
      assert html =~ listening_test.path
    end

    test "updates listening_test within modal", %{conn: conn, listening_test: listening_test} do
      {:ok, show_live, _html} = live(conn, ~p"/tests/#{listening_test}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Listening test"

      assert_patch(show_live, ~p"/tests/#{listening_test}/show/edit")

      assert show_live
             |> form("#listening_test-form", listening_test: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#listening_test-form", listening_test: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tests/#{listening_test}")

      html = render(show_live)
      assert html =~ "Listening test updated successfully"
      assert html =~ "some updated path"
    end
  end
end
