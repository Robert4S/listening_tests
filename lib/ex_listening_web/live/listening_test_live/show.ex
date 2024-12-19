defmodule ExListeningWeb.ListeningTestLive.Show do
  use ExListeningWeb, :live_view

  alias ExListening.ListeningTests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    test = ListeningTests.get_listening_test!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:listening_test, test)}
  end

  defp page_title(:show), do: "Show Listening test"
  defp page_title(:edit), do: "Edit Listening test"
end
