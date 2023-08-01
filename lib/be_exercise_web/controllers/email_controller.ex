defmodule BeExerciseWeb.EmailController do
  use BeExerciseWeb, :controller

  require Logger

  import Plug.Conn

  alias BeExercise.Infrastructure.SendEmail
  alias BeExerciseWeb.Controller.Helpers

  @spec invite_users(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def invite_users(conn, _params) do
    SendEmail.to_all_active_users()
    |> get_message_for_response()
    |> then(&Helpers.send_response(conn, 200, &1))
  end

  defp get_message_for_response({total_email, email_not_sent}) do
    case {total_email, email_not_sent} do
      {0, _} -> %{message: "No email sent"}
      {total, sent} when sent > 0 -> %{message: "#{total - sent} email sent, #{sent} not sent"}
      {total, _} -> %{message: "#{total} email sent"}
    end
  end
end
