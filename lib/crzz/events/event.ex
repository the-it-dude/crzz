defmodule Crzz.Events.Event do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Crzz.Events.Event
  alias Crzz.Events.EventUsers

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
  def upcoming_public_events_query(user, date) do
    query = from e in Event,
      left_join: eu in EventUsers,
      on: eu.event_id == e.id and eu.user_id == ^user.id,
      select: {
        e,
        eu,
        fragment(
          "(SELECT COUNT(0) FROM event_users
            WHERE event_users.event_id = ? and event_users.role = 'follower')",
          e.id),
        fragment(
          "(SELECT COUNT(0) FROM event_users
            WHERE event_users.event_id = ? and event_users.role in ('participant', 'manager', 'owner'))",
          e.id),
      },
      where:
        e.status == :published
        and e.start_date >= ^date

    {:ok, query}
  end

  @doc """
  Queries list of all events user has relation to.
  """
  def upcoming_events_for_user_query(user, date) do
    participant_roles = [:participant, :follower]
    manager_roles = [:owner, :manager]
    published_or_private = [:published, :private]
    query = from e in Event,
      inner_join: eu in EventUsers,
      on: eu.event_id == e.id,
      select: {
        e,
        eu,
        fragment(
          "(SELECT COUNT(0) FROM event_users
            WHERE event_users.event_id = ? and event_users.role = 'follower')",
          e.id),
        fragment(
          "(SELECT COUNT(0) FROM event_users
            WHERE event_users.event_id = ? and event_users.role in ('participant', 'manager', 'owner'))",
          e.id),
      },
      where:
        e.start_date >= ^date and eu.user_id == ^user.id
        and (
          (e.status in ^published_or_private and eu.role in ^participant_roles)
          or
          eu.role in ^manager_roles
        )

    {:ok, query}
  end
end
