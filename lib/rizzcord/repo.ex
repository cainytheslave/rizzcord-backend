defmodule Rizzcord.Repo do
  use Ecto.Repo,
    otp_app: :rizzcord,
    adapter: Ecto.Adapters.Postgres
end
