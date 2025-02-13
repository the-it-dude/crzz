defmodule Crzz.Repo.Migrations.CreateEventUsers do
  use Ecto.Migration

  def change do
    create table(:event_users, primary_key: false) do
      add :role, :string
      add :event_id, references(:events, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)


      timestamps(type: :utc_datetime)
    end

    create index(:event_users, [:event_id])
    create index(:event_users, [:user_id])
    create unique_index(:event_users, [:event_id, :user_id], name: :event_users_index)
  end
end
