defmodule BeExercise.Infrastructure.SendEmail do
  @moduledoc """
      Module created to send email using the BEChallengex library
      and retrieving data from database
  """
  alias BeExercise.Entity.User

  require Logger

  @doc """
  Send the email of all the active users retrieved from database. The response is a tuple with the number
    of total email and the number of email in error

  ## Parameters
    No parameter needed

  ## Examples
      iex> __MODULE__.to_all_active_users()
      {10, 1}
  """
  @spec to_all_active_users() :: {integer(), integer()}
  def to_all_active_users do
    all_active_users = User.get_all_active_users()
    total_email = length(all_active_users)

    all_active_users
    |> Task.async_stream(&send_email(&1))
    |> Enum.reduce([], fn
      {:ok, _}, acc -> acc
      {:error, name}, acc -> acc ++ [name]
    end)
    |> length()
    |> then(&Tuple.append({total_email}, &1))
  end

  defp send_email(email) do
    %{name: email}
    |> BEChallengex.send_email()
    |> manage_email_response(email)
  end

  defp manage_email_response({:ok, _}, name) do
    Logger.info("Email sent to #{name}")
    {:ok, name}
  end

  defp manage_email_response({:error, error}, name) do
    Logger.error("Email NOT sent to #{name} due to error: #{inspect(error)}")
    {:error, name}
  end
end
