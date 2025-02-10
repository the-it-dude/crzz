defmodule Crzz.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crzz.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_date: ~D[2025-02-09],
        start_date: ~D[2025-02-09],
        start_time: ~T[14:00:00],
        status: :draft,
        title: "some title",
        type: :cars_and_coffee
      })
      |> Crzz.Events.create_event()

    event
  end
end
