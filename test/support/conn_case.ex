defmodule ExListeningWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExListeningWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint ExListeningWeb.Endpoint

      use ExListeningWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExListeningWeb.ConnCase
    end
  end

  setup tags do
    ExListening.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in teachers.

      setup :register_and_log_in_teacher

  It stores an updated connection and a registered teacher in the
  test context.
  """
  def register_and_log_in_teacher(%{conn: conn}) do
    teacher = ExListening.TeachersFixtures.teacher_fixture()
    %{conn: log_in_teacher(conn, teacher), teacher: teacher}
  end

  @doc """
  Logs the given `teacher` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_teacher(conn, teacher) do
    token = ExListening.Teachers.generate_teacher_session_token(teacher)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:teacher_token, token)
  end
end
