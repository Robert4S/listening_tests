defmodule ExListening.DashboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExListening.Dashboard` context.
  """

  @doc """
  Generate a static.
  """
  def static_fixture(attrs \\ %{}) do
    {:ok, static} =
      attrs
      |> Enum.into(%{

      })
      |> ExListening.Dashboard.create_static()

    static
  end
end
