defmodule ExListeningWeb.DashboardLive.Index do
  use ExListeningWeb, :live_view

  @impl true
  def mount(_, _, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket), do: {:noreply, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <ul class="flex grid flex-col bg-gray-100 py-5 px-10 rounded-md items-center gap-4 font-semibold leading-6 text-zinc-900 text-center">
      <.header>Navigate</.header>
      <.link
        navigate="/students"
        class="hover:text-zinc-700 rounded-md bg-blue-100 py-1 px-2 font-semibold shadow"
      >
        Add or Edit Student
      </.link>
      <.link
        navigate="/classes"
        class="hover:text-zinc-700 rounded-md bg-blue-100 py-1 px-2 font-semibold shadow"
      >
        Add or Edit Class
      </.link>
      <.link
        navigate="/tests"
        class="hover:text-zinc-700 rounded-md bg-blue-100 py-1 px-2 font-semibold shadow"
      >
        Create, Edit, or Play Listening Test
      </.link>
      <.link
        navigate="/upload"
        class="hover:text-zinc-700 rounded-md bg-blue-100 py-1 px-2 font-semibold shadow"
      >
        Upload Audio File
      </.link>
    </ul>

    <div id="patch-into"></div>
    """
  end
end
