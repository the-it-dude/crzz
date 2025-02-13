defmodule Crzz.EventsTest do
  use Crzz.DataCase

  alias Crzz.Events

  describe "events" do
    alias Crzz.Events.Event

    import Crzz.EventsFixtures

    @invalid_attrs %{status: nil, type: nil, description: nil, title: nil, start_date: nil, end_date: nil, start_time: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{
        status: :draft,
        type: :cars_and_coffee,
        description: "some description",
        title: "some title",
        start_date: ~D[2025-02-09],
        end_date: ~D[2025-02-09],
        start_time: ~T[14:00:00],
        location_name: "Gulf of America",
      }

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.status == :draft
      assert event.type == :cars_and_coffee
      assert event.description == "some description"
      assert event.title == "some title"
      assert event.start_date == ~D[2025-02-09]
      assert event.end_date == ~D[2025-02-09]
      assert event.start_time == ~T[14:00:00]
      assert event.location_name == "Gulf of America"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{status: :published, type: :meeting, description: "some updated description", title: "some updated title", start_date: ~D[2025-02-10], end_date: ~D[2025-02-10], start_time: ~T[15:01:01]}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.status == :published
      assert event.type == :meeting
      assert event.description == "some updated description"
      assert event.title == "some updated title"
      assert event.start_date == ~D[2025-02-10]
      assert event.end_date == ~D[2025-02-10]
      assert event.start_time == ~T[15:01:01]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
