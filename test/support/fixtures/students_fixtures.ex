defmodule ExListening.StudentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExListening.Students` context.
  """

  @doc """
  Generate a student.
  """
  def student_fixture(attrs \\ %{}) do
    {:ok, student} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ExListening.Students.create_student()

    student
  end

  @doc """
  Generate a student.
  """
  def student_fixture(attrs \\ %{}) do
    {:ok, student} =
      attrs
      |> Enum.into(%{
        name: "some name",
        surname: "some surname"
      })
      |> ExListening.Students.create_student()

    student
  end
end
