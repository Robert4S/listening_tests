defmodule ExListening.Classes.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :name, :string
    field :year, :integer
    has_many :student, ExListening.Students.Student

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:year, :name])
    |> validate_required([:year, :name])
  end
end
