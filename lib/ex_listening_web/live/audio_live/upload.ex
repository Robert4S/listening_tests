defmodule ExListeningWeb.AudioLive.Upload do
  use ExListeningWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:uploaded_file, :none)
      |> allow_upload(:audio, accept: ~w(.mp3 .wav), max_entries: 1, max_file_size: 100_000_000)
      |> assign(:form, %{"file_name" => ""})
      |> assign(:error, [])

    {:ok, socket}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :audio, ref)}
  end

  @impl true
  def handle_event("save", %{"file_name" => filename}, socket) do
    if filename |> String.trim() == "" do
      {:noreply, assign(socket, :error, ["File name cannot be blank"])}
    else
      uploaded_files =
        consume_uploaded_entries(socket, :audio, fn %{path: path}, _entry ->
          dest =
            Path.join(
              Application.app_dir(:ex_listening, "priv/static/uploads"),
              filename
            )

          File.cp!(path, dest)
          {:ok, filename}
        end)

      socket =
        socket
        |> assign(:uploaded_file, {:some, uploaded_files})
        |> assign(:playback, :paused)

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate", %{"file_name" => filename}, socket) do
    if filename |> String.trim() == "" do
      {:noreply, assign(socket, :error, ["File name cannot be blank"])}
    else
      {:noreply, assign(socket, :error, [])}
    end
  end
end
