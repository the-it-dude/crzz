defmodule CrzzWeb.EventUsersControllerTest do
  use CrzzWeb.ConnCase

  import Crzz.AccountsFixtures
  import Crzz.EventsFixtures

  alias Crzz.Accounts
  # alias Crzz.Events.EventUsers

  # @create_attrs %{
  #   role: :owner
  # }
  # @update_attrs %{
  #   role: :manager
  # }
  # @invalid_attrs %{role: nil}

  setup %{conn: conn} do
    user = user_fixture()
    conn = conn
      |> Map.replace!(:secret_key_base, CrzzWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})
      |> put_req_header("authorization","Bearer " <> Accounts.create_user_api_token(user))
      |> put_req_header("accept", "application/json")
    {:ok, conn: conn, user: user, event: event_fixture()}
  end

  # describe "index" do
  #   test "lists all event_users", %{conn: conn} do
  #     conn = get(conn, ~p"/api/event_users")
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  # describe "create event_users" do
  #   test "renders event_users when data is valid", %{conn: conn, user: user, event: event} do
  #     user_id = user.id
  #     event_id = event.id
  #     conn = post(
  #       conn,
  #       ~p"/api/event_users",
  #       event_users: %{
  #         role: :owner,
  #         user_id: user_id,
  #         event_id: event_id,
  #       }
  #     )
  #     assert %{"user_id" => ^user_id, "event_id" => ^event_id, "role" => "owner"} = json_response(conn, 201)["data"]
  #
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, ~p"/api/event_users", event_users: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update event_users" do
  #   setup [:create_event_users]
  #
  #   test "renders event_users when data is valid", %{conn: conn, event_users: %EventUsers{id: id} = event_users} do
  #     conn = put(conn, ~p"/api/event_users/#{event_users}", event_users: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #
  #     conn = get(conn, ~p"/api/event_users/#{id}")
  #
  #     assert %{
  #              "id" => ^id,
  #              "role" => "manager"
  #            } = json_response(conn, 200)["data"]
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, event_users: event_users} do
  #     conn = put(conn, ~p"/api/event_users/#{event_users}", event_users: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end
  #
  # describe "delete event_users" do
  #   setup [:create_event_users]
  #
  #   test "deletes chosen event_users", %{conn: conn, event_users: event_users} do
  #     conn = delete(conn, ~p"/api/event_users/#{event_users}")
  #     assert response(conn, 204)
  #
  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/api/event_users/#{event_users}")
  #     end
  #   end
  # end

  # defp create_event_users(_) do
  #   event = event_fixture()
  #   user = user_fixture()
  #   event_users = event_users_fixture(%{user: user, event: event})
  #   %{event_users: event_users}
  # end
end
