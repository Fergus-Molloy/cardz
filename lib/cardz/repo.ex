defmodule Cardz.Repo do
  use Ecto.Repo,
    otp_app: :cardz,
    adapter: Ecto.Adapters.Postgres
end
