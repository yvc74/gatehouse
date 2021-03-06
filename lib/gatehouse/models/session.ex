defmodule Gatehouse.Session do
  alias Gatehouse.SessionManager

  def login(email, password) do
    user = SessionManager.get_principal_by_email(email)
    case authenticate(user, password) do
      true ->
        {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end
