defmodule ExListening.ListeningTestsTest do
  use ExListening.DataCase

  alias ExListening.ListeningTests

  describe "tests" do
    alias ExListening.ListeningTests.ListeningTest

    import ExListening.ListeningTestsFixtures

    @invalid_attrs %{file: nil}

    test "list_tests/0 returns all tests" do
      listening_test = listening_test_fixture()
      assert ListeningTests.list_tests() == [listening_test]
    end

    test "get_listening_test!/1 returns the listening_test with given id" do
      listening_test = listening_test_fixture()
      assert ListeningTests.get_listening_test!(listening_test.id) == listening_test
    end

    test "create_listening_test/1 with valid data creates a listening_test" do
      valid_attrs = %{file: "some file"}

      assert {:ok, %ListeningTest{} = listening_test} = ListeningTests.create_listening_test(valid_attrs)
      assert listening_test.file == "some file"
    end

    test "create_listening_test/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ListeningTests.create_listening_test(@invalid_attrs)
    end

    test "update_listening_test/2 with valid data updates the listening_test" do
      listening_test = listening_test_fixture()
      update_attrs = %{file: "some updated file"}

      assert {:ok, %ListeningTest{} = listening_test} = ListeningTests.update_listening_test(listening_test, update_attrs)
      assert listening_test.file == "some updated file"
    end

    test "update_listening_test/2 with invalid data returns error changeset" do
      listening_test = listening_test_fixture()
      assert {:error, %Ecto.Changeset{}} = ListeningTests.update_listening_test(listening_test, @invalid_attrs)
      assert listening_test == ListeningTests.get_listening_test!(listening_test.id)
    end

    test "delete_listening_test/1 deletes the listening_test" do
      listening_test = listening_test_fixture()
      assert {:ok, %ListeningTest{}} = ListeningTests.delete_listening_test(listening_test)
      assert_raise Ecto.NoResultsError, fn -> ListeningTests.get_listening_test!(listening_test.id) end
    end

    test "change_listening_test/1 returns a listening_test changeset" do
      listening_test = listening_test_fixture()
      assert %Ecto.Changeset{} = ListeningTests.change_listening_test(listening_test)
    end
  end

  describe "tests" do
    alias ExListening.ListeningTests.ListeningTest

    import ExListening.ListeningTestsFixtures

    @invalid_attrs %{path: nil, description: nil}

    test "list_tests/0 returns all tests" do
      listening_test = listening_test_fixture()
      assert ListeningTests.list_tests() == [listening_test]
    end

    test "get_listening_test!/1 returns the listening_test with given id" do
      listening_test = listening_test_fixture()
      assert ListeningTests.get_listening_test!(listening_test.id) == listening_test
    end

    test "create_listening_test/1 with valid data creates a listening_test" do
      valid_attrs = %{path: "some path", description: "some description"}

      assert {:ok, %ListeningTest{} = listening_test} = ListeningTests.create_listening_test(valid_attrs)
      assert listening_test.path == "some path"
      assert listening_test.description == "some description"
    end

    test "create_listening_test/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ListeningTests.create_listening_test(@invalid_attrs)
    end

    test "update_listening_test/2 with valid data updates the listening_test" do
      listening_test = listening_test_fixture()
      update_attrs = %{path: "some updated path", description: "some updated description"}

      assert {:ok, %ListeningTest{} = listening_test} = ListeningTests.update_listening_test(listening_test, update_attrs)
      assert listening_test.path == "some updated path"
      assert listening_test.description == "some updated description"
    end

    test "update_listening_test/2 with invalid data returns error changeset" do
      listening_test = listening_test_fixture()
      assert {:error, %Ecto.Changeset{}} = ListeningTests.update_listening_test(listening_test, @invalid_attrs)
      assert listening_test == ListeningTests.get_listening_test!(listening_test.id)
    end

    test "delete_listening_test/1 deletes the listening_test" do
      listening_test = listening_test_fixture()
      assert {:ok, %ListeningTest{}} = ListeningTests.delete_listening_test(listening_test)
      assert_raise Ecto.NoResultsError, fn -> ListeningTests.get_listening_test!(listening_test.id) end
    end

    test "change_listening_test/1 returns a listening_test changeset" do
      listening_test = listening_test_fixture()
      assert %Ecto.Changeset{} = ListeningTests.change_listening_test(listening_test)
    end
  end
end
