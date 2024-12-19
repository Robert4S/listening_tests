defmodule ExListeningWeb.ListeningTestLive.Index do
  use ExListeningWeb, :live_view

  alias ExListening.ListeningTests
  alias ExListening.ListeningTests.ListeningTest

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tests, ListeningTests.list_tests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Listening test")
    |> assign(:listening_test, ListeningTests.get_listening_test!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Listening test")
    |> assign(:listening_test, %ListeningTest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tests")
    |> assign(:listening_test, nil)
  end

  @impl true
  def handle_info({ExListeningWeb.ListeningTestLive.FormComponent, {:saved, listening_test}}, socket) do
    {:noreply, stream_insert(socket, :tests, listening_test)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    listening_test = ListeningTests.get_listening_test!(id)
    {:ok, _} = ListeningTests.delete_listening_test(listening_test)

    {:noreply, stream_delete(socket, :tests, listening_test)}
  end
end
