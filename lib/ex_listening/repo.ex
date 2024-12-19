defmodule ExListening.Repo do
  use Ecto.Repo,
    otp_app: :ex_listening,
    adapter: Ecto.Adapters.SQLite3
end
