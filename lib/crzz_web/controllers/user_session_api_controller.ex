defmodule CrzzWeb.UserSessionAPIController do
  use CrzzWeb, :controller

  alias Crzz.Accounts
  alias Crzz.Accounts.User

  action_fallback CrzzWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by_email_and_password(email, password) do
      token = Accounts.create_user_api_token(user)
      conn
        |> put_resp_content_type("application/json")
        |> send_resp(:created, Jason.encode!(%{"token" => token}))
    else
      _ ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(:unauthorized, Jason.encode!(%{"error" => "Invalid credentials."}))
    end
  end
end
