defmodule Crzz.Repo do
  use Ecto.Repo,
    otp_app: :crzz,
    adapter: Ecto.Adapters.Postgres
end
