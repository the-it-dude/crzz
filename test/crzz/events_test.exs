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

  describe "event_users" do
    alias Crzz.Events.EventUsers

    import Crzz.AccountsFixtures
    import Crzz.EventsFixtures

    @invalid_attrs %{role: nil}

    test "list_event_users/0 returns all event_users" do
      event_users = event_users_fixture()
      [event_user] = Events.list_event_users()

      assert event_user.role == :owner
      assert event_user.user_id == event_users.user_id
      assert event_user.event_id == event_users.event_id
    end

    # test "get_event_users!/1 returns the event_users with given id" do
    #   event_users = event_users_fixture()
    #   assert Events.get_event_users!(event_users.id) == event_users
    # end

    test "create_event_users/1 with valid data creates a event_users" do
      user = user_fixture()
      event = event_fixture()

      valid_attrs = %{role: :owner, user_id: user.id, event_id: event.id}

      assert {:ok, %EventUsers{} = event_users} = Events.create_event_users(valid_attrs)
      assert event_users.role == :owner
      assert event_users.user_id == user.id
      assert event_users.event_id == event.id
    end

    test "create_event_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event_users(@invalid_attrs)
    end

    # test "update_event_users/2 with valid data updates the event_users" do
    #   event_users = event_users_fixture()
    #   update_attrs = %{role: :manager}
    #
    #   assert {:ok, %EventUsers{} = event_users} = Events.update_event_users(event_users, update_attrs)
    #   assert event_users.role == :manager
    # end

    # test "update_event_users/2 with invalid data returns error changeset" do
    #   event_users = event_users_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Events.update_event_users(event_users, @invalid_attrs)
    #   assert event_users == Events.get_event_users!(event_users.id)
    # end
    #
    # test "delete_event_users/1 deletes the event_users" do
    #   event_users = event_users_fixture()
    #   assert {:ok, %EventUsers{}} = Events.delete_event_users(event_users)
    #   assert_raise Ecto.NoResultsError, fn -> Events.get_event_users!(event_users.id) end
    # end

    test "change_event_users/1 returns a event_users changeset" do
      event_users = event_users_fixture()
      assert %Ecto.Changeset{} = Events.change_event_users(event_users)
    end
  end
end
