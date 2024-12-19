defmodule ExListening.UploadsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExListening.Uploads` context.
  """

  @doc """
  Generate a upload.
  """
  def upload_fixture(attrs \\ %{}) do
    {:ok, upload} =
      attrs
      |> Enum.into(%{
        path: "some path"
      })
      |> ExListening.Uploads.create_upload()

    upload
  end

  @doc """
  Generate a upload.
  """
  def upload_fixture(attrs \\ %{}) do
    {:ok, upload} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ExListening.Uploads.create_upload()

    upload
  end

  @doc """
  Generate a upload.
  """
  def upload_fixture(attrs \\ %{}) do
    {:ok, upload} =
      attrs
      |> Enum.into(%{
        name: "some name",
        origin: "some origin"
      })
      |> ExListening.Uploads.create_upload()

    upload
  end
end
