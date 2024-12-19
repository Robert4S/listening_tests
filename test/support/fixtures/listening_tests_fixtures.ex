defmodule ExListening.ListeningTestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExListening.ListeningTests` context.
  """

  @doc """
  Generate a listening_test.
  """
  def listening_test_fixture(attrs \\ %{}) do
    {:ok, listening_test} =
      attrs
      |> Enum.into(%{
        file: "some file"
      })
      |> ExListening.ListeningTests.create_listening_test()

    listening_test
  end

  @doc """
  Generate a listening_test.
  """
  def listening_test_fixture(attrs \\ %{}) do
    {:ok, listening_test} =
      attrs
      |> Enum.into(%{
        description: "some description",
        path: "some path"
      })
      |> ExListening.ListeningTests.create_listening_test()

    listening_test
  end
end
