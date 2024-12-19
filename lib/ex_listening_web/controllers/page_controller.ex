defmodule ExListeningWeb.PageController do
  use ExListeningWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/join")
  end

  def dashboard(conn, _params) do
    render(conn, :static)
  end
end
