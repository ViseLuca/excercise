defmodule BeExerciseWeb.UserJSON do
  require Logger

  def show_users_and_salaries(%{users: users}) do
    %{data: format_for_response(users)}
  end

  defp format_for_response(salaries_list) when is_list(salaries_list) do
    Logger.info("#{length(salaries_list)} users found")

    Enum.map(salaries_list, &format_for_response/1)
  end

  defp format_for_response(%{name: name, amount: salary, currency: currency}) do
    %{name: name, salary: salary, currency: currency}
  end
end
