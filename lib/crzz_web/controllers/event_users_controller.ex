defmodule CrzzWeb.EventUsersController do
  use CrzzWeb, :controller

  alias Crzz.Events
  alias Crzz.Events.EventUsers

  action_fallback CrzzWeb.FallbackController

  def index(conn, _params) do
    event_users = Events.list_event_users()
    render(conn, :index, event_users: event_users)
  end

  def create(conn, %{"event_users" => event_users_params}) do
    with {:ok, %EventUsers{} = event_users} <- Events.create_event_users(event_users_params) do
      conn
      |> put_status(:created)
      |> render(:show, event_users: event_users)
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
