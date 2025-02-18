defmodule CrzzWeb.EventUsersJSON do
  alias Crzz.Events.EventUsers

  @doc """
  Renders a list of event_users.
  """
  def index(%{event_users: event_users}) do
    %{data: for(event_users <- event_users, do: data(event_users))}
  end

  @doc """
  Renders a single event_users.
  """
  def show(%{event_users: event_users}) do
    %{data: data(event_users)}
   end

  @doc """
  Renders error in update.
  """
  def role_error(%{error_message: error_message}) do
    %{error: error_message}
  end

  defp data(%EventUsers{} = event_users) do
    %{
      user_id: event_users.user_id,
      event_id: event_users.event_id,
      role: event_users.role
    }
  end
end
