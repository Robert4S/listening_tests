defmodule ExListeningWeb.StaticControllerTest do
  use ExListeningWeb.ConnCase

  import ExListening.DashboardFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all dashboards", %{conn: conn} do
      conn = get(conn, ~p"/dashboards")
      assert html_response(conn, 200) =~ "Listing Dashboards"
    end
  end

  describe "new static" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/dashboards/new")
      assert html_response(conn, 200) =~ "New Static"
    end
  end

  describe "create static" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/dashboards", static: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/dashboards/#{id}"

      conn = get(conn, ~p"/dashboards/#{id}")
      assert html_response(conn, 200) =~ "Static #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/dashboards", static: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Static"
    end
  end

  describe "edit static" do
    setup [:create_static]

    test "renders form for editing chosen static", %{conn: conn, static: static} do
      conn = get(conn, ~p"/dashboards/#{static}/edit")
      assert html_response(conn, 200) =~ "Edit Static"
    end
  end

  describe "update static" do
    setup [:create_static]

    test "redirects when data is valid", %{conn: conn, static: static} do
      conn = put(conn, ~p"/dashboards/#{static}", static: @update_attrs)
      assert redirected_to(conn) == ~p"/dashboards/#{static}"

      conn = get(conn, ~p"/dashboards/#{static}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, static: static} do
      conn = put(conn, ~p"/dashboards/#{static}", static: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Static"
    end
  end

  describe "delete static" do
    setup [:create_static]

    test "deletes chosen static", %{conn: conn, static: static} do
      conn = delete(conn, ~p"/dashboards/#{static}")
      assert redirected_to(conn) == ~p"/dashboards"

      assert_error_sent 404, fn ->
        get(conn, ~p"/dashboards/#{static}")
      end
    end
  end

  defp create_static(_) do
    static = static_fixture()
    %{static: static}
  end
end
