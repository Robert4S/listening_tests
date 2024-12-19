defmodule ExListening.ListeningTests.ListeningTest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tests" do
    field :path, :string
    field :description, :string
    field :class_id, :id
    field :code, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(listening_test, attrs) do
    listening_test
    |> cast(attrs, [:path, :description, :class_id, :code])
    |> validate_required([:path, :description, :class_id, :code])
  end
end
