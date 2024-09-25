defmodule BeExercise.Infrastructure.Oban.SendEmail do
  @moduledoc """
      Module created to send email through oban using the BEChallengex library
      and retrieving data from database
  """
  use Oban.Worker, queue: :users_invitations

  alias BeExercise.Context.User

  require Logger

  @doc """
  Send the email of all the active users retrieved from database is called by the oban instance automatically
  """
  @impl Worker
  def perform(%Oban.Job{}) do
    all_active_users =
      User.get_all_active_users_salaries()

    email_not_sent =
      all_active_users
      |> Task.async_stream(&send_email(&1))
      |> Enum.reduce([], fn
        {:ok, _}, acc -> acc
        {:error, name}, acc -> acc ++ [name]
      end)
      |> length()

    if email_not_sent > 0 do
      Logger.warning("Email on error: #{email_not_sent} of #{length(all_active_users)}")
    end

    :ok
  end

  defp send_email([name, id]) do
    %{name: name}
    |> BEChallengex.send_email()
    |> manage_email_response(id)
  end

  defp manage_email_response({:ok, _}, id) do
    Logger.info("Email sent to user_id: #{id}")
    {:ok, id}
  end

  defp manage_email_response({:error, error}, id) do
    Logger.error("Email NOT sent to user_id: #{id} due to error: #{inspect(error)}")
    {:error, id}
  end
end
