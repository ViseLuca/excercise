defmodule BeExerciseWeb.UserController do
  use BeExerciseWeb, :controller

  import Phoenix.Controller
  import Plug.Conn

  alias BeExercise.Entity.Salary
  alias BeExercise.OpenApi.Response.User, as: UserResponse
  alias BeExerciseWeb.Controller.Helpers
  alias OpenApiSpex.Operation

  require Logger

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
        Operation.parameter(:name, :path, :string, "Name", example: "Luca"),
        Operation.parameter(:orderBy, :path, :string, "Order By", example: "asc")
      ],
      responses: %{
        200 => Operation.response("User", "application/json", UserResponse)
      }
    }
  end

  @spec get_users(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def get_users(conn, params) do
    params
    |> Salary.get_active_or_the_most_recent_salaries()
    |> format_for_response()
    |> then(&Helpers.send_response(conn, 200, &1))
  end

  defp format_for_response([] = salaries_list) do
    Logger.warning("No user found")
    salaries_list
  end

  defp format_for_response(salaries_list) do
    Logger.info("#{length(salaries_list)} users found")

    Enum.map(salaries_list, fn %{name: name, amount: salary, currency: currency} ->
      %{name: name, salary: "#{salary} #{currency}"}
    end)
  end
end
