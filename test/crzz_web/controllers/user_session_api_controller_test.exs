defmodule CrzzWeb.UserSessionAPIControllerTest do
  use CrzzWeb.ConnCase, async: true

  alias Crzz.Accounts
  import Crzz.AccountsFixtures

  setup %{conn: conn} do
    conn = conn
      |> Map.replace!(:secret_key_base, CrzzWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})
      |> put_req_header("accept", "application/json")
    %{conn: conn}
  end

  describe "create token" do
    test "returns valid token on success", %{conn: conn} do
      user = user_fixture()
      conn = post(conn, ~p"/api/token", email: user.email, password: valid_user_password())

      assert response(conn, :created)
      assert token = json_response(conn, :created)["token"]

      assert {:ok, user} == Accounts.fetch_user_by_api_token(token)
    end

    test "returns error if email incorrect", %{conn: conn} do
      user_fixture()

      conn = post(conn, ~p"/api/token", email: "test@nonsense.com", password: valid_user_password())

      assert response(conn, :unauthorized)
      assert %{"error" => "Invalid credentials."} = json_response(conn, :unauthorized)
    end

    test "returns error if password incorrect", %{conn: conn} do
      user = user_fixture()

      conn = post(conn, ~p"/api/token", email: user.email, password: "rubbish")

      assert response(conn, :unauthorized)
      assert %{"error" => "Invalid credentials."} = json_response(conn, :unauthorized)
    end
  end

end
