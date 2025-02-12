defmodule Crzz.Repo.Migrations.AddLocationNameToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add_if_not_exists :location_name, :string
    end

  end
end
