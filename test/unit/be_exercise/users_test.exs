defmodule Unit.BeExercise.UsersTest do
  @moduledoc false

  use BeExercise.DataCase, async: true
  alias BeExercise.Fixtures
  alias BeExercise.Context.User

  describe "Users extractions" do
    test "Retrieve just the users with active salaries" do
      user = Fixtures.insert_user()
      Fixtures.insert_salary(10, "EUR", user.id, true)

      user2 = Fixtures.insert_user("Gabriele")
      Fixtures.insert_salary(10, "EUR", user2.id, false)

      response = User.get_all_active_users_salaries()

      assert 0 ===
               response
               |> Enum.filter(fn elem ->
                 elem |> List.first() |> Kernel.==("Gabriele")
               end)
               |> length()

      assert 1 ===
               response
               |> Enum.filter(fn elem ->
                 elem |> List.first() |> Kernel.==("Luca")
               end)
               |> length()
    end
  end
end
