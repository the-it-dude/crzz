defmodule CrzzWeb.EventJSON do
  alias Crzz.Events.Event
  alias Crzz.Events.EventUsers

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a list of events with roles.
  """
  def user_events(%{events: events}) do
    %{data: for(event_and_role <- events, do: event_and_role_data(event_and_role))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      title: event.title,
      status: event.status,
      type: event.type,
      description: event.description,
      start_date: event.start_date,
      end_date: event.end_date,
      start_time: event.start_time,
      location: event.location,
      location_name: event.location_name,
    }
  end

  defp event_and_role_data({%Event{} = event, %EventUsers{} = user_role}) do
    %{
      id: event.id,
      title: event.title,
      status: event.status,
      type: event.type,
      description: event.description,
      start_date: event.start_date,
      end_date: event.end_date,
      start_time: event.start_time,
      location: event.location,
      location_name: event.location_name,
      role: user_role.role,
    }
  end
end
