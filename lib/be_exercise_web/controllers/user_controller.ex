defmodule BeExerciseWeb.UserController do
  use BeExerciseWeb, :controller

  import Phoenix.Controller
  import Plug.Conn

  alias BeExercise.Context.Salary
  alias BeExercise.OpenApi.Response.User, as: UserResponse
  alias OpenApiSpex.Operation
  alias OpenApiSpex.Schema
  alias OpenApiSpex.Plug.CastAndValidate

  require Logger

  action_fallback BeExerciseWeb.FallbackController

  @spec open_api_operation(any) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  @spec get_users_operation() :: Operation.t()
  def get_users_operation do
    %Operation{
      tags: ["users"],
      summary: "Show all the users with the active salary or the last active salary",
      description: "Show users by name and salary",
      operationId: "UserController.show",
      parameters: [
        Operation.parameter(:name, :query, :string, "Name", example: "Luca"),
        Operation.parameter(
          :orderBy,
          :query,
          %Schema{type: :string, enum: ["ASC", "DESC", "asc", "desc"]},
          "orderBy",
          example: "ASC"
        )
      ],
      responses: %{
        200 => Operation.response("User list", "application/json", UserResponse)
      }
    }
  end

  plug CastAndValidate, query: BeExercise.OpenApi.Request.User

  @spec get_users(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def get_users(conn, params) do
    params
    |> Salary.get_active_or_the_most_recent_salaries()
    |> then(&render(conn, :show_users_and_salaries, users: &1))
  end
end
