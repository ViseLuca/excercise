defmodule Unit.BeExercise.UsersTest do
  @moduledoc false

  use BeExercise.DataCase, async: true

  alias BeExercise.Payroll.User
  alias BeExercise.Fixtures

  describe "Users extractions" do
    test "Retrieve just the users with active salaries" do
      user = Fixtures.insert_user()
      Fixtures.insert_salary(10, "EUR", user.id, true)

      user2 = Fixtures.insert_user("Gabriele")
      Fixtures.insert_salary(10, "EUR", user2.id, false)

      response = User.get_all_active_users_salaries()

      assert 0 === count_users(response, "Gabriele")

      assert 1 === count_users(response, "Luca")
    end
  end

  defp count_users(response, expected_name) do
    response
    |> Enum.filter(fn %{name: name} -> name === expected_name end)
    |> length()
  end
end
