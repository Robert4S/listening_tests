defmodule ExListeningWeb.ListeningTestLive.FormComponent do
  use ExListeningWeb, :live_component

  alias ExListening.ListeningTests
  alias ExListening.Classes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="listening_test-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
          field={@form[:path]}
          type="select"
          label="File name"
          options={Enum.map(@files, &{&1, &1})}
        />

        <.input
          field={@form[:class_id]}
          type="select"
          label="Class"
          options={Enum.map(@classes, &{"#{&1.year}#{&1.name}", &1.id})}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Listening test</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{listening_test: listening_test} = assigns, socket) do
    classes = Classes.list_classes()
    {:ok, files} = File.ls(Application.app_dir(:ex_listening, "priv/static/uploads"))

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:classes, classes)
     |> assign(:files, files)
     |> assign_new(:form, fn ->
       to_form(ListeningTests.change_listening_test(listening_test))
     end)}
  end

  @impl true
  def handle_event("validate", %{"listening_test" => listening_test_params}, socket) do
    changeset =
      ListeningTests.change_listening_test(socket.assigns.listening_test, listening_test_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"listening_test" => listening_test_params}, socket) do
    save_listening_test(socket, socket.assigns.action, listening_test_params)
  end

  defp save_listening_test(socket, :edit, listening_test_params) do
    case ListeningTests.update_listening_test(
           socket.assigns.listening_test,
           listening_test_params
         ) do
      {:ok, listening_test} ->
        notify_parent({:saved, listening_test})

        {:noreply,
         socket
         |> put_flash(:info, "Listening test updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_listening_test(socket, :new, listening_test_params) do
    case ListeningTests.create_listening_test(
           listening_test_params
           |> Map.put("code", RandomString.generate(5))
         ) do
      {:ok, listening_test} ->
        notify_parent({:saved, listening_test})

        {:noreply,
         socket
         |> put_flash(:info, "Listening test created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
