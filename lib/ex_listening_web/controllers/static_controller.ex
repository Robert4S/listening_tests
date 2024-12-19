defmodule ExListeningWeb.StaticController do
  use ExListeningWeb, :controller

  alias ExListening.Dashboard
  alias ExListening.Dashboard.Static

  def static(conn, _params) do
    render(conn, "static.html")
  end
end
