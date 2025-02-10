defmodule Crzz.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

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
    field :location, Geo.PostGIS.Geometry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :status, :type, :description, :start_date, :end_date, :start_time])
    |> validate_required([:title, :status, :type, :description, :start_date, :end_date, :start_time])
  end
end
