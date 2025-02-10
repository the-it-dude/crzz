defmodule Crzz.Repo.Migrations.AddLocationToEvents do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS postgis")

    execute("SELECT AddGeometryColumn('events', 'location', 4326, 'POINT', 2)")
    execute("CREATE INDEX events_location_index on events USING gist (location)")

  end

  def down do
    execute("DROP INDEX events_location_index")
    execute("SELECT DropGeometryColumn ('events', 'location')")

    execute("DROP EXTENSION IF EXISTS postgis")
  end
 end
