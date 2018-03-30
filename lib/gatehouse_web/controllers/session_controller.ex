defmodule GatehouseWeb.SessionController do
  use GatehouseWeb, :controller
  alias Gatehouse.Target

  def error(conn, _params) do
    render conn, "index.html"
  end

  def index(conn, %{ "target" => target }) do
    render conn, "index.html", target: target
  end

  def index(conn, params) do
    index conn, Map.put(params, "target", "/session" )
  end

  def session(conn, %{ "access_token" => token }) do
    {:ok, claims} = Gatehouse.Guardian.decode_and_verify(token)
    render conn, "session.html", claims: inspect(claims)
  end

  def goto(conn, %{"target" => target}) do
    token = Gatehouse.CurrentSession.token(conn)
    redirect(conn, external:  Target.add_access_token_to_uri(target, token))
  end

  def create(conn, %{"session" => %{"email" => email,
                                  "password" => password,
                                  "target" => target}}) do
    case Gatehouse.Session.login(Gatehouse.Repo, email, password) do
      {:ok, user} ->
        conn
        |> Gatehouse.Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/goto?target=#{target}")
      :error ->
        conn
        |> put_flash(:error, "Wrong email or password")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _) do
    conn
    |> Gatehouse.Guardian.Plug.sign_out()
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
