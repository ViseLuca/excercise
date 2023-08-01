defmodule BeExercise.Infrastructure.SendEmail do
  @moduledoc """
      Module created to send email using the BEChallengex library
      and retrieving data from database
  """
  alias BeExercise.Entity.User

  require Logger

  @chunk_size 1000

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
    |> Enum.chunk_every(@chunk_size)
    |> Enum.map(&Task.async(fn -> send_emails(&1) end))
    |> Enum.reduce([], &(&2 ++ Task.await(&1)))
    |> length()
    |> then(&Tuple.append({total_email}, &1))
  end

  defp send_emails(emails) do
    Enum.reduce(emails, [], fn name, errors ->
      %{name: name}
      |> BEChallengex.send_email()
      |> manage_email_response(name, errors)
    end)
  end

  defp manage_email_response({:ok, _}, name, email_errors) do
    Logger.info("Email sent to #{name}")
    email_errors
  end

  defp manage_email_response({:error, error}, name, email_errors) do
    Logger.error("Email NOT sent to #{name} due to error: #{inspect(error)}")
    email_errors ++ [name]
  end
end
