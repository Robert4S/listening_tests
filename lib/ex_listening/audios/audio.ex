defmodule ExListening.Audios.Audio do
  use Ecto.Schema
  import Ecto.Changeset

  schema "audios" do
    field :path, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(audio, attrs) do
    audio
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
end
