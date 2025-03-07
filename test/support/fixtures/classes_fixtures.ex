defmodule ExListening.ClassesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExListening.Classes` context.
  """

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        name: "some name",
        year: 42
      })
      |> ExListening.Classes.create_class()

    class
  end
end
