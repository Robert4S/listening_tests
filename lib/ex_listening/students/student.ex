defmodule ExListening.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student" do
    field :name, :string
    field :surname, :string
    field :class_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:name, :surname, :class_id])
    |> validate_required([:name, :surname, :class_id])
  end
end
