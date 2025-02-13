defmodule Crzz.Events.EventUsers do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "event_users" do
    field :role, Ecto.Enum, values: [:owner, :manager, :participant, :follower]
    belongs_to :event, Crzz.Events.Event
    belongs_to :user, Crzz.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event_users, attrs) do
    event_users
    |> cast(attrs, [:role, :user_id, :event_id])
    |> validate_required([:role, :user_id, :event_id])
  end
end
