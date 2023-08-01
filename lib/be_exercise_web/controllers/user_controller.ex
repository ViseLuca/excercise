defmodule BeExerciseWeb.UserController do
  use BeExerciseWeb, :controller

  import Phoenix.Controller
  import Plug.Conn

  alias BeExercise.Entity.Salary
  alias BeExerciseWeb.Controller.Helpers

  require Logger

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
