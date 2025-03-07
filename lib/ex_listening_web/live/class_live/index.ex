defmodule ExListeningWeb.ClassLive.Index do
  use ExListeningWeb, :live_view

  alias ExListening.Classes
  alias ExListening.Classes.Class
  alias ExListening.Repo

  @impl true
  def mount(_params, _session, socket) do
    classes = Classes.list_classes()
    {:ok, stream(socket, :classes, classes)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Class")
    |> assign(:class, Classes.get_class!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Class")
    |> assign(:class, %Class{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Classes")
    |> assign(:class, nil)
  end

  @impl true
  def handle_info({ExListeningWeb.ClassLive.FormComponent, {:saved, class}}, socket) do
    {:noreply, stream_insert(socket, :classes, class)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    class = Classes.get_class!(id)
    {:ok, _} = Classes.delete_class(class)

    {:noreply, stream_delete(socket, :classes, class)}
  end
end
