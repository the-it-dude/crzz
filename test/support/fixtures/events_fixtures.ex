defmodule Crzz.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crzz.Events` context.
  """

  import Crzz.AccountsFixtures

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_date: Date.utc_today(),
        start_date: Date.utc_today(),
        start_time: ~T[14:00:00],
        status: :draft,
        title: "some title",
        type: :cars_and_coffee,
        location_name: "Los Alamos",
      })
      |> Crzz.Events.create_event()

    event
  end

  @doc """
  Generate a event_users.
  """
  def event_users_fixture(attrs \\ %{}) do
    role = Map.get(attrs, :role, :owner)
    event = Map.get(attrs, :event, event_fixture())
    user = Map.get(attrs, :user, user_fixture())

    {:ok, event_users} = Crzz.Events.create_event_users(%{
      role: role,
      event_id: event.id,
      user_id: user.id,
    })

    event_users
  end
end
