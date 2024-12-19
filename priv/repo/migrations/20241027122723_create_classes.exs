defmodule ExListening.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :year, :integer
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
