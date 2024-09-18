defmodule Unit.BeExercise.SalariesTest do
  @moduledoc false

  use BeExercise.DataCase, async: true
  alias BeExercise.Fixtures

  describe "Salary insertions" do
    test "does not allow negative amount" do
      user = Fixtures.insert_user()

      response =
        try do
          Fixtures.insert_salary(-10, "EUR", user.id, true)
        rescue
          e in Ecto.ConstraintError -> e
        end

      assert "amount_cannot_be_negative" = response.constraint
    end

    test "allows unlimited inactive salaries" do
      user = Fixtures.insert_user()
      Fixtures.insert_salary(1_000, "EUR", user.id, false)
      Fixtures.insert_salary(10_000, "EUR", user.id, false)
      Fixtures.insert_salary(100_000, "EUR", user.id, false)
      Fixtures.insert_salary(1_000_000, "EUR", user.id, false)
      Fixtures.insert_salary(10_000_000, "EUR", user.id, false)
      Fixtures.insert_salary(100_00_000, "EUR", user.id, false)
    end

    test "every user can have at most one active salary" do
      user = Fixtures.insert_user()
      Fixtures.insert_salary(10_000_000, "EUR", user.id, true)

      response =
        try do
          Fixtures.insert_salary(1_000_000, "USD", user.id, true)
        rescue
          e in Ecto.ConstraintError -> e
        end

      assert "just_one_active_salary" = response.constraint
    end
  end
end
