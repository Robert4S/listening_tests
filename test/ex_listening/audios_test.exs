defmodule ExListening.AudiosTest do
  use ExListening.DataCase

  alias ExListening.Audios

  describe "audios" do
    alias ExListening.Audios.Audio

    import ExListening.AudiosFixtures

    @invalid_attrs %{path: nil}

    test "list_audios/0 returns all audios" do
      audio = audio_fixture()
      assert Audios.list_audios() == [audio]
    end

    test "get_audio!/1 returns the audio with given id" do
      audio = audio_fixture()
      assert Audios.get_audio!(audio.id) == audio
    end

    test "create_audio/1 with valid data creates a audio" do
      valid_attrs = %{path: "some path"}

      assert {:ok, %Audio{} = audio} = Audios.create_audio(valid_attrs)
      assert audio.path == "some path"
    end

    test "create_audio/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audios.create_audio(@invalid_attrs)
    end

    test "update_audio/2 with valid data updates the audio" do
      audio = audio_fixture()
      update_attrs = %{path: "some updated path"}

      assert {:ok, %Audio{} = audio} = Audios.update_audio(audio, update_attrs)
      assert audio.path == "some updated path"
    end

    test "update_audio/2 with invalid data returns error changeset" do
      audio = audio_fixture()
      assert {:error, %Ecto.Changeset{}} = Audios.update_audio(audio, @invalid_attrs)
      assert audio == Audios.get_audio!(audio.id)
    end

    test "delete_audio/1 deletes the audio" do
      audio = audio_fixture()
      assert {:ok, %Audio{}} = Audios.delete_audio(audio)
      assert_raise Ecto.NoResultsError, fn -> Audios.get_audio!(audio.id) end
    end

    test "change_audio/1 returns a audio changeset" do
      audio = audio_fixture()
      assert %Ecto.Changeset{} = Audios.change_audio(audio)
    end
  end
end
