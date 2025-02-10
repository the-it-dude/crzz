defmodule Crzz.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :status, :string
      add :type, :string
      add :description, :text
      add :start_date, :date
      add :end_date, :date
      add :start_time, :time

      timestamps(type: :utc_datetime)
    end
  end
end
