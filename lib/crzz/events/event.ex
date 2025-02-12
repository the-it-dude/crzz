defmodule Crzz.Events.Event do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Crzz.Events.Event

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :status, Ecto.Enum, values: [:draft, :published, :private, :deleted]
    field :type, Ecto.Enum, values: [:cars_and_coffee, :meeting, :drive, :other]
    field :description, :string
    field :title, :string
    field :start_date, :date
    field :end_date, :date
    field :start_time, :time
    field :location_name, :string
    field :location, Geo.PostGIS.Geometry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :status, :type, :description, :start_date, :end_date, :start_time, :location_name, :location])
    |> validate_required([:title, :status, :type, :description, :start_date, :start_time, :location_name])
  end

  @doc """
  Queries list all of public events with starting date from given date.
  """
  def upcoming_public_events_query(date) do
    from e in Event, where: e.status == :published and e.start_date >= ^date
  end
end
