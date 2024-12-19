defmodule ExListening.Repo.Migrations.InsertTeacher do
  use Ecto.Migration

  def change do
    alias ExListening.Teachers
    alias ExListening.Repo
    alias ExListening.Teachers.Teacher

    teacher_params = %{
      "email" => "admin@gmail.com",
      "password" => "admin12345678"
    }

    case Repo.get_by(Teacher, email: teacher_params["email"]) do
      nil ->
        Teachers.register_teacher(teacher_params)

      _ ->
        :ok
    end
  end
end
