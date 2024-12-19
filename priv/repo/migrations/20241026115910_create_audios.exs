defmodule ExListening.Repo.Migrations.CreateAudios do
  use Ecto.Migration

  def change do
    create table(:audios) do
      add :path, :string

      timestamps(type: :utc_datetime)
    end
  end
end
