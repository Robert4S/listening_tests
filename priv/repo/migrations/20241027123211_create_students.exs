defmodule ExListening.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:student) do
      add :name, :string
      add :surname, :string
      add :class_id, references(:classes, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:student, [:class_id])
  end
end
