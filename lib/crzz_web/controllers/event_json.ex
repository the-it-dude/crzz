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
  def show(%{event: event_and_role}) do
    %{data: event_and_role_data(event_and_role)}
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
    event_data = data(event)
    Map.put(event_data, :role, user_role.role)
  end

  defp event_and_role_data({%Event{} = event, user_role, follower_count, participant_count}) do
    event_data = data(event)
    |> Map.put(:role, nil)
    |> Map.put(:followers, follower_count)
    |> Map.put(:participants, participant_count)

    if user_role == nil do
      event_data
    else
      Map.put(event_data, :role, user_role.role)
    end
  end

end
