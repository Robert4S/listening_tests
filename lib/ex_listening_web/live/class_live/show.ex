defmodule ExListeningWeb.ClassLive.Show do
  alias ExListening.Repo
  use ExListeningWeb, :live_view

  alias ExListening.Classes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:class, Classes.get_class!(id) |> Repo.preload(:student))}
  end

  defp page_title(:show), do: "Show Class"
  defp page_title(:edit), do: "Edit Class"
end
