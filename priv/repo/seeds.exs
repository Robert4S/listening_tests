# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExListening.Repo.insert!(%ExListening.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

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
