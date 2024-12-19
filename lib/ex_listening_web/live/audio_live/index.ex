defmodule ExListeningWeb.AudioLive.Index do
  alias Phoenix.PubSub
  use ExListeningWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    code = RandomString.generate(5)

    PubSub.subscribe(ExListening.PubSub, "classroom_#{code}")

    socket =
      socket
      |> assign(:uploaded_file, :none)
      |> assign(:classroom_code, code)
      |> assign(:playback, :none)
      |> assign(:students, [])
      |> allow_upload(:audio, accept: ~w(.mp3 .wav), max_entries: 1)

    {:ok, socket}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :audio, ref)}
  end

  @impl true
  def handle_event("save", _, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :audio, fn %{path: path}, _entry ->
        dest =
          Path.join(
            Application.app_dir(:ex_listening, "priv/static/uploads"),
            Path.basename(path)
          )

        File.cp!(path, dest)
        {:ok, Path.basename(path)}
      end)

    socket =
      socket
      |> assign(:uploaded_file, {:some, uploaded_files})
      |> assign(:playback, :paused)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("play", _params, socket) do
    socket =
      socket
      |> assign(:playback, :played)

    PubSub.broadcast(ExListening.PubSub, "classroom_#{socket.assigns.classroom_code}", :play)
    {:noreply, socket}
  end

  def handle_event("pause", _params, socket) do
    socket =
      socket
      |> assign(:playback, :paused)

    PubSub.broadcast(ExListening.PubSub, "classroom_#{socket.assigns.classroom_code}", :pause)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:filename, pid}, socket) do
    filename = socket.assigns.uploaded_file
    send(pid, {:filename_response, filename})
    {:noreply, socket}
  end

  def handle_info(:play, socket), do: {:noreply, socket}
  def handle_info(:pause, socket), do: {:noreply, socket}

  @impl true
  def terminate(_, %{assigns: %{uploaded_file: {:some, file}}} = socket) do
    file =
      Path.join(
        Application.app_dir(:ex_listening, "priv/static/uploads"),
        Path.basename(file)
      )

    code = socket.assigns.classroom_code
    File.rm!(file)
    PubSub.unsubscribe(ExListening.PubSub, "classroom_#{code}")
    PubSub.broadcast(ExListening.PubSub, "classroom_#{code}", :end)
  end
end

defmodule RandomString do
  def generate(length) when length > 0 do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.encode64()
    |> binary_part(0, length)
  end
end
