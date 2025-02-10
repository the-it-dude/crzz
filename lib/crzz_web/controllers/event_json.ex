defmodule CrzzWeb.EventJSON do
  alias Crzz.Events.Event

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
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
      start_time: event.start_time
    }
  end
end
