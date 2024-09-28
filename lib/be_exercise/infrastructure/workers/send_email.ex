defmodule BeExercise.Infrastructure.Workers.SendEmail do
  @moduledoc """
      Module created to send email through oban using the BEChallengex library
      and retrieving data from database
  """
  use Oban.Worker, queue: :users_invitations

  require Logger

  @doc """
  Send the email of all the active users retrieved from database is called by the oban instance automatically
  """
  @impl Worker
  def perform(%Oban.Job{args: %{"name" => name, "id" => id}}) do
    send_email(name, id)
  end

  defp send_email(name, id) do
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
