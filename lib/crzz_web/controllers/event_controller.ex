defmodule CrzzWeb.EventController do
  use CrzzWeb, :controller

  alias Crzz.Events
  alias Crzz.Events.Event

  action_fallback CrzzWeb.FallbackController

  def index(conn, _params) do
    events = Events.list_upcoming_public_events()
    render(conn, :index, events: events)
  end

  def list_user_events(conn, _params) do
    events_and_roles = Events.list_upcoming_user_events(conn.assigns[:current_user])
    render(conn, :user_events, events: events_and_roles)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Events.create_event_for_user(conn.assigns[:current_user], event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/events/#{event}")
      |> render(:show, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, :show, event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      render(conn, :show, event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)

    with {:ok, %Event{}} <- Events.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
