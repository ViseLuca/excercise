defmodule BeExerciseWeb.UserJSON do
  require Logger

  def show_users_and_salaries(%{users: users}) do
    format_for_response(users)
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
