defmodule GatehouseWeb.SessionController do
  use GatehouseWeb, :controller
  alias Gatehouse.Target
  alias Gatehouse.CreateAdminManager
  alias Gatehouse.Session

  def login(conn, %{ "target" => target }) do
    if CreateAdminManager.has_admin() do
      render conn, "login.html", target: target
    else
      conn |> redirect(to: "/create_admin")
    end
  end

  def login(conn, params) do
    login conn, Map.put(params, "target", "/" )
  end

  def index(conn, %{ "target" => target }) do
    conn |> redirect(to: "/goto?target=#{target}")  
  end

  def index(conn, %{ "access_token" => token }) do
    {:ok, claims} = Gatehouse.Guardian.decode_and_verify(token)
    render conn, "session_with_token.html", claims: inspect(claims)
  end

  def index(conn, _params) do
    render conn, "session.html"
  end

  def goto(conn, %{"target" => target}) do
    token = Gatehouse.CurrentSession.token(conn)
    redirect(conn, external:  Target.add_access_token_to_uri(target, token))
  end

  def create(conn, %{"session" => %{"email" => email,
                                  "password" => password,
                                  "target" => target}}) do
    case Session.login(email, password) do
      {:ok, user} ->
        conn
        |> Gatehouse.Guardian.Plug.sign_in(user)
        |> put_flash(:info, gettext("Logged in"))
        |> redirect(to: "/goto?target=#{target}")
      :error ->
        conn
        |> put_flash(:error, gettext("Wrong email or password"))
        |> redirect(to: "/")
    end
  end

  def delete(conn, _) do
    conn
    |> Gatehouse.Guardian.Plug.sign_out()
    |> put_flash(:info, gettext("Logged out"))
    |> redirect(to: "/login")
  end

end
