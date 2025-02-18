defmodule CrzzWeb.EventControllerTest do
  use CrzzWeb.ConnCase, async: true

  alias Crzz.Accounts
  alias Crzz.Accounts.User
  alias Crzz.Events.Event

  import Crzz.AccountsFixtures
  import Crzz.EventsFixtures

  @create_attrs %{
    status: :draft,
    type: :cars_and_coffee,
    description: "some description",
    title: "some title",
    start_date: ~D[2025-02-09],
    end_date: ~D[2025-02-09],
    start_time: ~T[14:00:00],
    location_name: "Los Alamos",
  }
  @update_attrs %{
    status: :private,
    type: :meeting,
    description: "some updated description",
    title: "some updated title",
    start_date: ~D[2025-02-10],
    end_date: ~D[2025-02-10],
    start_time: ~T[15:01:01],
    location_name: "Market Square, Lviv"
  }
  @invalid_attrs %{status: nil, type: nil, description: nil, title: nil, start_date: nil, end_date: nil, start_time: nil}

  setup %{conn: conn} do
    user = user_fixture()
    conn = conn
      |> Map.replace!(:secret_key_base, CrzzWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})
      |> put_req_header("authorization","Bearer " <> Accounts.create_user_api_token(user))
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/api/events")

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "list_user_events" do
    test "lists draft events only for manager", %{conn: conn, user: user} do
      owner_event = event_fixture()
      event_users_fixture(%{event: owner_event, role: :owner, user: user})
      manager_event = event_fixture()
      event_users_fixture(%{event: manager_event, role: :owner})
      event_users_fixture(%{event: manager_event, role: :manager, user: user})

      draft_following_event = event_fixture(%{status: :draft})
      event_users_fixture(%{event: draft_following_event, user: user, role: :follower})
      conn = get(conn, ~p"/api/events/my")

      assert json_response(conn, 200)["data"] == [
        %{
          "id" => owner_event.id,
          "description" => owner_event.description,
          "title" => owner_event.title,
          "start_date" => to_string(owner_event.start_date),
          "end_date" => to_string(owner_event.end_date),
          "location" => owner_event.location,
          "location_name" => owner_event.location_name,
          "start_time" => to_string(owner_event.start_time),
          "status" => to_string(owner_event.status),
          "type" => to_string(owner_event.type),
          "role" => "owner",
          "followers" => 0,
          "participants" => 1,
        },
        %{
          "id" => manager_event.id,
          "description" => manager_event.description,
          "title" => manager_event.title,
          "start_date" => to_string(manager_event.start_date),
          "end_date" => to_string(manager_event.end_date),
          "location" => manager_event.location,
          "location_name" => manager_event.location_name,
          "start_time" => to_string(manager_event.start_time),
          "status" => to_string(manager_event.status),
          "type" => to_string(manager_event.type),
          "role" => "manager",
          "followers" => 0,
          "participants" => 2,
        }
      ]
    end
    test "lists published events only as follower and participant", %{conn: conn, user: user} do
      following_event = event_fixture(%{status: :published})
      event_users_fixture(%{event: following_event, role: :follower, user: user})
      participating_event = event_fixture(%{status: :private})
      event_users_fixture(%{event: participating_event, role: :participant, user: user})

      conn = get(conn, ~p"/api/events/my")

      assert json_response(conn, 200)["data"] == [
        %{
          "id" => following_event.id,
          "description" => following_event.description,
          "title" => following_event.title,
          "start_date" => to_string(following_event.start_date),
          "end_date" => to_string(following_event.end_date),
          "location" => following_event.location,
          "location_name" => following_event.location_name,
          "start_time" => to_string(following_event.start_time),
          "status" => to_string(following_event.status),
          "type" => to_string(following_event.type),
          "role" => "follower",
          "followers" => 1,
          "participants" => 0,
        },
        %{
          "id" => participating_event.id,
          "description" => participating_event.description,
          "title" => participating_event.title,
          "start_date" => to_string(participating_event.start_date),
          "end_date" => to_string(participating_event.end_date),
          "location" => participating_event.location,
          "location_name" => participating_event.location_name,
          "start_time" => to_string(participating_event.start_time),
          "status" => to_string(participating_event.status),
          "type" => to_string(participating_event.type),
          "role" => "participant",
          "followers" => 0,
          "participants" => 1,
        }
      ]
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "end_date" => "2025-02-09",
               "start_date" => "2025-02-09",
               "start_time" => "14:00:00",
               "status" => "draft",
               "title" => "some title",
               "type" => "cars_and_coffee"
             } = json_response(conn, 200)["data"]



    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event, user: %User{} = user} do
      event_users_fixture(%{event: event, role: :owner, user: user})
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = conn
        |> recycle()
        |> assign(:current_user, user)
      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "end_date" => "2025-02-10",
               "start_date" => "2025-02-10",
               "start_time" => "15:01:01",
               "status" => "private",
               "title" => "some updated title",
               "type" => "meeting"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: %Event{} = event, user: %User{} = user} do
      event_users_fixture(%{event: event, role: :owner, user: user})
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event, user: user} do
      event_users_fixture(%{event: event, role: :owner, user: user})
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
