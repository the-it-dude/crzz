defmodule CrzzWeb.EventControllerTest do
  use CrzzWeb.ConnCase, async: true

  alias Crzz.Accounts
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

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = conn
        |> recycle()
        |> assign(:current_user, user_fixture())
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

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
