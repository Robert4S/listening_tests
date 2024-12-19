defmodule ExListeningWeb.ErrorJSONTest do
  use ExListeningWeb.ConnCase, async: true

  test "renders 404" do
    assert ExListeningWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ExListeningWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
