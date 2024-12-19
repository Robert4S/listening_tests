defmodule ExListening.ListeningTests do
  @moduledoc """
  The ListeningTests context.
  """

  import Ecto.Query, warn: false
  alias ExListening.Repo

  alias ExListening.ListeningTests.ListeningTest

  @doc """
  Returns the list of tests.

  ## Examples

      iex> list_tests()
      [%ListeningTest{}, ...]

  """
  def list_tests do
    Repo.all(ListeningTest)
  end

  @doc """
  Gets a single listening_test.

  Raises `Ecto.NoResultsError` if the Listening test does not exist.

  ## Examples

      iex> get_listening_test!(123)
      %ListeningTest{}

      iex> get_listening_test!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listening_test!(id), do: Repo.get!(ListeningTest, id)

  def get_listening_test_by_code(code) do
    Repo.get_by(ListeningTest, code: code)
  end

  @doc """
  Creates a listening_test.

  ## Examples

      iex> create_listening_test(%{field: value})
      {:ok, %ListeningTest{}}

      iex> create_listening_test(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_listening_test(attrs \\ %{}) do
    %ListeningTest{}
    |> ListeningTest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a listening_test.

  ## Examples

      iex> update_listening_test(listening_test, %{field: new_value})
      {:ok, %ListeningTest{}}

      iex> update_listening_test(listening_test, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_listening_test(%ListeningTest{} = listening_test, attrs) do
    listening_test
    |> ListeningTest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a listening_test.

  ## Examples

      iex> delete_listening_test(listening_test)
      {:ok, %ListeningTest{}}

      iex> delete_listening_test(listening_test)
      {:error, %Ecto.Changeset{}}

  """
  def delete_listening_test(%ListeningTest{} = listening_test) do
    Repo.delete(listening_test)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking listening_test changes.

  ## Examples

      iex> change_listening_test(listening_test)
      %Ecto.Changeset{data: %ListeningTest{}}

  """
  def change_listening_test(%ListeningTest{} = listening_test, attrs \\ %{}) do
    ListeningTest.changeset(listening_test, attrs)
  end
end
