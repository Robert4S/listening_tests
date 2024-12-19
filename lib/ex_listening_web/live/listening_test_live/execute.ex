defmodule ExListeningWeb.ListeningTestLive.Execute do
  use ExListeningWeb, :live_view

  alias ExListening.Students.Student
  alias ExListening.Repo
  alias Phoenix.PubSub
  alias ExListening.ListeningTests.ListeningTest
  alias ExListening.ListeningTests

  defp students_by_test_code(code) do
    import Ecto.Query

    from test in ListeningTest,
      where: test.code == ^code,
      join: student in Student,
      on: student.class_id == test.class_id,
      select: %{name: student.name, surname: student.surname}
  end

  defp name_and_surname_by_id(id) do
    import Ecto.Query

    from student in Student,
      where: student.id == ^id,
      select: %{name: student.name, surname: student.surname}
  end

  # Allows for a custom poll event to be handled every 500ms
  @poll_interval 3000
  defp schedule_poll(polling) do
    Process.send_after(self(), {:poll, polling}, @poll_interval)
  end

  # Set state to all students missing by default
  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    # Fetches the listening test corresponding to the id
    listening_test = ListeningTests.get_listening_test!(id)
    code = listening_test.code

    # This is the channel where the student connections and the teacher connection can communicate
    PubSub.subscribe(ExListening.PubSub, "classroom_#{code}")

    # students_by_test_code is a SQL query, and Repo.all fetches the list of students that the query selects
    students = Repo.all(students_by_test_code(code))

    socket =
      socket
      |> assign(
        # Assign all the necessary fields in the connection's state
        listening_test: listening_test,
        classroom_code: code,
        class_students: students,
        missing: students,
        playback: :unstarted,
        students: [],
        student_buffer: [],
        missing_buffer: students
      )

    # Schedule polling student processes to see who is present in the listening test
    schedule_poll(true)

    {:ok, socket}
  end

  # Tell student connections to play when teacher plays audio
  @impl true
  def handle_event("play", _params, socket) do
    socket =
      socket
      |> assign(:playback, :played)

    PubSub.broadcast(ExListening.PubSub, "classroom_#{socket.assigns.classroom_code}", :play)
    {:noreply, socket}
  end

  # Tell student connections to pause when teacher pauses audio
  def handle_event("pause", _params, socket) do
    socket =
      socket
      |> assign(:playback, :paused)

    PubSub.broadcast(ExListening.PubSub, "classroom_#{socket.assigns.classroom_code}", :pause)
    {:noreply, socket}
  end

  # Tell student connections to scrub to a certain time when teacher scrubs to that time
  def handle_event("scrub", %{"time" => time}, socket) do
    PubSub.broadcast(
      ExListening.PubSub,
      "classroom_#{socket.assigns.classroom_code}",
      {:scrub_to, time}
    )

    {:noreply, socket}
  end

  def handle_event("playback", %{"time" => time, "state" => state, "pid" => pid}, socket) do
    {:ok, pid} = ets_lookup(pid)
    send(pid, {:playback_state, %{time: time, state: state}})

    {:noreply, socket}
  end

  # Send the audio file location when student connections query for it
  @impl true
  def handle_info({:filename, pid}, socket) do
    filename = socket.assigns.listening_test.path
    send(pid, {:filename_response, filename})
    {:noreply, socket}
  end

  # Updates the present/missing buffers when to update the student list, students send this when :who is broadcasted
  def handle_info({:me, student_id}, socket) do
    student = Repo.one(name_and_surname_by_id(student_id))

    students = [student | socket.assigns.student_buffer]

    missing = Enum.filter(socket.assigns.missing_buffer, &(&1 !== student))

    socket =
      socket
      |> assign(:student_buffer, students)
      |> assign(:missing_buffer, missing)

    {:noreply, socket}
  end

  # Poll in listen mode, only update buffers, don't update the rendered state
  def handle_info({:poll, true}, socket) do
    code = socket.assigns.classroom_code
    PubSub.broadcast(ExListening.PubSub, "classroom_#{code}", {:who, self()})
    schedule_poll(false)

    {:noreply, socket}
  end

  # Poll in update mode, update the present/missing lists to reflect the buffers,
  # effectively rendering the results of the last @poll_interval timeframe of polling
  def handle_info({:poll, false}, socket) do
    students = socket.assigns.student_buffer
    missing = socket.assigns.missing_buffer
    class_students = socket.assigns.class_students

    socket =
      socket
      |> assign(:students, students)
      |> assign(:student_buffer, [])
      |> assign(:missing, missing)
      |> assign(:missing_buffer, class_students)

    schedule_poll(true)

    {:noreply, socket}
  end

  def handle_info({:join, pid}, socket) do
    id = inspect(pid)
    :ets.insert(:pids_table, {id, pid})

    socket =
      socket
      |> push_event("playback", %{pid: id})

    {:noreply, socket}
  end

  def handle_info({:scrub_to, _time}, socket) do
    {:noreply, socket}
  end

  def handle_info(:play, socket) do
    {:noreply, socket}
  end

  def handle_info(:pause, socket) do
    {:noreply, socket}
  end

  def handle_info({:who, _}, socket), do: {:noreply, socket}

  def ets_lookup(key) do
    case :ets.lookup(:pids_table, key) do
      [{^key, pid}] -> {:ok, pid}
      [] -> :error
    end
  end
end
