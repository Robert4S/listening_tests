defmodule ExListening.AudiosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExListening.Audios` context.
  """

  @doc """
  Generate a audio.
  """
  def audio_fixture(attrs \\ %{}) do
    {:ok, audio} =
      attrs
      |> Enum.into(%{
        path: "some path"
      })
      |> ExListening.Audios.create_audio()

    audio
  end
end
