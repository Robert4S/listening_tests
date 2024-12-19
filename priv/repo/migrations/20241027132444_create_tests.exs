defmodule ExListening.Repo.Migrations.CreateTests do
  use Ecto.Migration

  def change do
    create table(:tests) do
      add :path, :string
      add :description, :string
      add :code, :string
      add :class_id, references(:classes, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tests, [:class_id])
  end
end
