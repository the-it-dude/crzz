defmodule Crzz.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query
  alias Crzz.Repo

  alias Crzz.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  List Events for a user.

      iex> list_upcoming_user_events(user)
      [%Event{}, ...]

  """
  def list_upcoming_user_events(user) do
    with {:ok, query} <- Event.upcoming_events_for_user_query(user, Date.utc_today()) do
      Repo.all(query)
    end
  end

  @doc """
  List upcoming published events.
  """
  def list_upcoming_public_events do
    with {:ok, query} <- Event.upcoming_public_events_query(Date.utc_today()) do
      Repo.all(query)
    end
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates event for a user.

  ## Examples

      iex> create_event_for_user(user, %{field: value})
      {:ok, %Event{}}

      iex> create_event_for_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_event_for_user(user, attrs \\ %{}) do
    case create_event(attrs) do
      {:ok, %Event{} = event} ->
        add_user_to_event(user, event, :owner)
        {:ok, event}
      error ->
        error
    end
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias Crzz.Events.EventUsers

  @doc """
  Mark User as Event Owner.

  Examples:

      iex> add_user_to_event(user, event, role)
      {:ok, %EventUsers{}}

      iex> add_user_to_event(user, event, :incorrect_role)
      {:error, %Ecto.Changeset{}}
  """
  def add_user_to_event(user, event, role) do
    attrs = %{
      user_id: user.id,
      event_id: event.id,
      role: role
    }
    %EventUsers{}
    |> EventUsers.changeset(attrs)
    |> Repo.insert(
      conflict_target: [:user_id, :event_id],
      on_conflict: [set: [role: role]]
    )
  end

  @doc """
  Returns the list of event_users.

  ## Examples

      iex> list_event_users()
      [%EventUsers{}, ...]

  """
  def list_event_users do
    Repo.all(EventUsers)
    |> Repo.preload(:user)
    |> Repo.preload(:event)
  end

  @doc """
  Gets a single event_users.

  Raises `Ecto.NoResultsError` if the Event users does not exist.

  ## Examples

      iex> get_event_users!(1, 2)
      %EventUsers{}

      iex> get_event_users!(456, 33)
      ** (Ecto.NoResultsError)

  """
  def get_event_users!(event_id, user_id), do: Repo.one!(
        from eu in EventUsers,
        where: eu.event == ^event_id and eu.user == ^user_id
      )

  @doc """
  Creates a event_users.

  ## Examples

      iex> create_event_users(%{field: value})
      {:ok, %EventUsers{}}

      iex> create_event_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_users(attrs \\ %{}) do
    %EventUsers{}
    |> EventUsers.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_users.

  ## Examples

      iex> update_event_users(event_users, %{field: new_value})
      {:ok, %EventUsers{}}

      iex> update_event_users(event_users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_users(%EventUsers{} = event_users, attrs) do
    event_users
    |> EventUsers.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event_users.

  ## Examples

      iex> delete_event_users(event_users)
      {:ok, %EventUsers{}}

      iex> delete_event_users(event_users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_users(%EventUsers{} = event_users) do
    Repo.delete(event_users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_users changes.

  ## Examples

      iex> change_event_users(event_users)
      %Ecto.Changeset{data: %EventUsers{}}

  """
  def change_event_users(%EventUsers{} = event_users, attrs \\ %{}) do
    EventUsers.changeset(event_users, attrs)
  end
end
