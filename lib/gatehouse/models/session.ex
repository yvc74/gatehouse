defmodule Gatehouse.Session do

  def login(repo, email, password) do
    user = Gatehouse.SessionManager.get_principal_by_email(repo, email)
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
