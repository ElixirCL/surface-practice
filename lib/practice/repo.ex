defmodule Practice.Repo do
  use Ecto.Repo,
    otp_app: :practice,
    adapter: Ecto.Adapters.SQLite3
end
