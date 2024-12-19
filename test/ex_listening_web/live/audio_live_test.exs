defmodule ExListeningWeb.AudioLiveTest do
  use ExListeningWeb.ConnCase

  import Phoenix.LiveViewTest
  import ExListening.AudiosFixtures

  @create_attrs %{path: "some path"}
  @update_attrs %{path: "some updated path"}
  @invalid_attrs %{path: nil}

  defp create_audio(_) do
    audio = audio_fixture()
    %{audio: audio}
  end

  describe "Index" do
    setup [:create_audio]

    test "lists all audios", %{conn: conn, audio: audio} do
      {:ok, _index_live, html} = live(conn, ~p"/audios")

      assert html =~ "Listing Audios"
      assert html =~ audio.path
    end

    test "saves new audio", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/audios")

      assert index_live |> element("a", "New Audio") |> render_click() =~
               "New Audio"

      assert_patch(index_live, ~p"/audios/new")

      assert index_live
             |> form("#audio-form", audio: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#audio-form", audio: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/audios")

      html = render(index_live)
      assert html =~ "Audio created successfully"
      assert html =~ "some path"
    end

    test "updates audio in listing", %{conn: conn, audio: audio} do
      {:ok, index_live, _html} = live(conn, ~p"/audios")

      assert index_live |> element("#audios-#{audio.id} a", "Edit") |> render_click() =~
               "Edit Audio"

      assert_patch(index_live, ~p"/audios/#{audio}/edit")

      assert index_live
             |> form("#audio-form", audio: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#audio-form", audio: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/audios")

      html = render(index_live)
      assert html =~ "Audio updated successfully"
      assert html =~ "some updated path"
    end

    test "deletes audio in listing", %{conn: conn, audio: audio} do
      {:ok, index_live, _html} = live(conn, ~p"/audios")

      assert index_live |> element("#audios-#{audio.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#audios-#{audio.id}")
    end
  end

  describe "Show" do
    setup [:create_audio]

    test "displays audio", %{conn: conn, audio: audio} do
      {:ok, _show_live, html} = live(conn, ~p"/audios/#{audio}")

      assert html =~ "Show Audio"
      assert html =~ audio.path
    end

    test "updates audio within modal", %{conn: conn, audio: audio} do
      {:ok, show_live, _html} = live(conn, ~p"/audios/#{audio}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Audio"

      assert_patch(show_live, ~p"/audios/#{audio}/show/edit")

      assert show_live
             |> form("#audio-form", audio: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#audio-form", audio: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/audios/#{audio}")

      html = render(show_live)
      assert html =~ "Audio updated successfully"
      assert html =~ "some updated path"
    end
  end
end
