defmodule ExListening.DashboardTest do
  use ExListening.DataCase

  alias ExListening.Dashboard

  describe "dashboards" do
    alias ExListening.Dashboard.Static

    import ExListening.DashboardFixtures

    @invalid_attrs %{}

    test "list_dashboards/0 returns all dashboards" do
      static = static_fixture()
      assert Dashboard.list_dashboards() == [static]
    end

    test "get_static!/1 returns the static with given id" do
      static = static_fixture()
      assert Dashboard.get_static!(static.id) == static
    end

    test "create_static/1 with valid data creates a static" do
      valid_attrs = %{}

      assert {:ok, %Static{} = static} = Dashboard.create_static(valid_attrs)
    end

    test "create_static/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_static(@invalid_attrs)
    end

    test "update_static/2 with valid data updates the static" do
      static = static_fixture()
      update_attrs = %{}

      assert {:ok, %Static{} = static} = Dashboard.update_static(static, update_attrs)
    end

    test "update_static/2 with invalid data returns error changeset" do
      static = static_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_static(static, @invalid_attrs)
      assert static == Dashboard.get_static!(static.id)
    end

    test "delete_static/1 deletes the static" do
      static = static_fixture()
      assert {:ok, %Static{}} = Dashboard.delete_static(static)
      assert_raise Ecto.NoResultsError, fn -> Dashboard.get_static!(static.id) end
    end

    test "change_static/1 returns a static changeset" do
      static = static_fixture()
      assert %Ecto.Changeset{} = Dashboard.change_static(static)
    end
  end
end
