defmodule CrzzWeb.EventUsersController do
  use CrzzWeb, :controller

  alias Crzz.Events
  alias Crzz.Events.Event
  alias Crzz.Events.EventUsers

  action_fallback CrzzWeb.FallbackController

  def index(conn, _params) do
    event_users = Events.list_event_users()
    render(conn, :index, event_users: event_users)
  end

  # def create(conn, %{"event_users" => event_users_params}) do
  #   with {:ok, %EventUsers{} = event_users} <- Events.create_event_users(event_users_params) do
  #     conn
  #     |> put_status(:created)
  #     |> render(:show, event_users: event_users)
  #   end
  # end

  def my_role(conn, %{"event_id" => event_id, "role" => role}) when role in ["follower", "participant"] do
    user = conn.assigns[:current_user]
    case Events.get_event_for_user!(event_id, user) do
      {%Event{} = _, %EventUsers{} = event_users} ->
        if event_users.role == role do
          conn
          |> put_status(:bad_request)
          |> render(:role_error, error_message: "You already have this role")
        else
          {:ok, %EventUsers{} = updated} = Events.update_event_users(event_id, user.id, role)
          conn
          |> render(:show, event_users: updated)
        end

      {%Event{} = _, nil} ->
        {:ok, %EventUsers{} = event_users} = Events.create_event_users(%{
          event_id: event_id,
          user_id: user.id,
          role: role
        })
        conn
        |> render(:show, event_users: event_users)
    end
  end

  def my_role(conn, %{"role" => _}) do
    conn
    |> put_status(:bad_request)
    |> render(:role_error, error_message: "Incorrect role provided.")
  end

  def remove_my_role(conn, %{"event_id" => event_id}) do
    user = conn.assigns[:current_user]
    case Events.get_event_for_user!(event_id, user) do
      {%Event{} = _, %EventUsers{} = event_users} ->
        if event_users.role == :owner do
          conn
          |> put_status(:bad_request)
          |> render(:role_error, error_message: "You are event owner.")
        else
          Events.delete_event_users(event_id, user.id)
          send_resp(conn, :no_content, "")
        end
      {%Event{} = _, nil} ->
        send_resp(conn, :no_content, "")
    end
  end

  # def show(conn, %{"id" => id}) do
  #   event_users = Events.get_event_users!(id)
  #   render(conn, :show, event_users: event_users)
  # end
  #
  # def update(conn, %{"id" => id, "event_users" => event_users_params}) do
  #   event_users = Events.get_event_users!(id)
  #
  #   with {:ok, %EventUsers{} = event_users} <- Events.update_event_users(event_users, event_users_params) do
  #     render(conn, :show, event_users: event_users)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   event_users = Events.get_event_users!(id)
  #
  #   with {:ok, %EventUsers{}} <- Events.delete_event_users(event_users) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
