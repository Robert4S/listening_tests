defmodule ExListeningWeb.StudentJoin.Index do
  alias ExListening.Students
  alias ExListening.ListeningTests
  alias ExListening.Repo
  alias ExListening.Classes
  alias Phoenix.PubSub
  use ExListeningWeb, :live_view

  # Initialisation logic for student connections
  @impl true
  def mount(_params, _session, socket) do
    # Prepare all possible classes
    classes = Classes.list_classes()

    # Preload the student list for the first class, and if there are no classes, dont laod any students
    students =
      case classes do
        [default | _] -> Repo.preload(default, :student).student
        _ -> []
      end

    # Set the fields of the state
    socket =
      socket
      # Pre loaded form data
      |> assign(:form, %{"classroom_code" => "", "class_id" => nil, "student_id" => nil})
      # All available classes from the database to choose in the form
      |> assign(:classes, classes)
      # The students from the default class
      |> assign(:students, students)
      # The test has not ended
      |> assign(:ongoing, true)
      |> assign(:playback, :not_joined)

    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket), do: {:noreply, socket}

  @impl true
  # Join form submission
  def handle_event("join", %{"classroom_code" => code, "student_id" => id}, socket) do
    # Strip whitespace
    code = String.trim(code)

    # Validate that there is a listening test corresponding to the classroom code entered by the student
    class = ListeningTests.get_listening_test_by_code(code)

    # If there is no class, with that code, the student has entered an incorrect code
    if is_nil(class) do
      socket =
        socket
        # Notify them of the error
        |> put_flash(:error, "No classroom found with that code")

      {:noreply, socket}
    else
      student = Students.get_student!(id)

      socket =
        socket
        |> assign(:classroom_code, code)
        |> assign(:student_id, id)
        |> assign(:student_name, student.name)

      # Subscribe to the message broadcast channel for the listening test
      PubSub.subscribe(ExListening.PubSub, "classroom_#{code}")

      # Broadcast that this process has joined
      PubSub.broadcast(ExListening.PubSub, "classroom_#{code}", {:join, self()})
      # Request the audio file name for the listening test
      PubSub.broadcast(ExListening.PubSub, "classroom_#{code}", {:filename, self()})

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate", %{"class_selector" => id}, socket) do
    # Update the available student list to only include students from the selected class
    id = String.to_integer(id)
    class = Classes.get_class!(id) |> Repo.preload(:student)
    students = class.student

    {:noreply, assign(socket, students: students)}
  end

  @impl true
  # Play message is recieved
  def handle_info(:play, socket) do
    socket =
      socket
      # Push a "play" event to the browser-side javascript to interact with the Audio object in
      # the students' browser
      |> push_event("play", %{})
      # Store the new state for display purposes
      |> assign(:playback, :played)

    {:noreply, socket}
  end

  # Pause message recieved
  def handle_info(:pause, socket) do
    socket =
      socket
      # Push a "pause" event to the browser-sid
      |> push_event("pause", %{})
      # Store the new state for display purposes
      |> assign(:playback, :paused)

    {:noreply, socket}
  end

  # Responding to teacher process' poll
  def handle_info({:who, pid}, %{assigns: %{student_id: id}} = socket) do
    # Send this students ID to the teacher process telling it the student is still present
    send(pid, {:me, id})
    {:noreply, socket}
  end

  # The teacher sent the file name after querying for it
  def handle_info({:filename_response, filename}, socket) do
    socket =
      socket
      # Send the file name and a javascript event for the browser, so that the browser
      # side code can then get the audio data from /uploads/´filename´
      |> push_event("set_source", %{source: filename})
      |> assign(:playback, :paused)

    {:noreply, socket}
  end

  # Teacher sent a scrub event
  def handle_info({:scrub_to, time}, socket) do
    socket =
      socket
      # Tell browser side code to scrub to the correct time
      |> push_event("scrub_to", %{time: time})

    {:noreply, socket}
  end

  # Teacher responded to a query for the full state
  def handle_info({:playback_state, %{state: state, time: time}}, socket) do
    socket =
      socket
      # Tell JS to scrub to time
      |> push_event("scrub_to", %{time: time})
      # Tell JS to pause if it should be paused, vice versa for play
      |> push_event(if(state === "paused", do: "pause", else: "play"), %{})

    {:noreply, socket}
  end

  def handle_info({:filename, _}, socket), do: {:noreply, socket}
  def handle_info({:join, _}, socket), do: {:noreply, socket}
end
