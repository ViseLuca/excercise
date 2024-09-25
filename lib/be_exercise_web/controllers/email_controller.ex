defmodule BeExerciseWeb.EmailController do
  use BeExerciseWeb, :controller

  require Logger

  import Plug.Conn

  alias BeExercise.Infrastructure.Oban.SendEmail

  alias BeExercise.OpenApi.Response.Email, as: EmailResponse
  alias OpenApiSpex.Operation

  require Logger

  action_fallback BeExerciseWeb.FallbackController

  @spec open_api_operation(any) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  @spec invite_users_operation() :: Operation.t()
  def invite_users_operation do
    %Operation{
      tags: ["email"],
      summary: "Invite all the active users",
      description: "Send email to all the active users",
      operationId: "EmailController.show",
      parameters: [],
      responses: %{
        202 => Operation.response("Email", "application/json", EmailResponse)
      }
    }
  end

  @spec invite_users(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def invite_users(conn, _params) do
    %{}
    |> SendEmail.new()
    |> Oban.insert()
    |> case do
      {:ok, _} -> send_resp(conn, 202, "Job scheduled")
      error -> error
    end
  end
end
