defmodule BeExercise.Factory do
  @moduledoc """
  Module to help in the tests to create structs passing some data
  """
  alias BeExercise.Schema.Salary
  alias BeExercise.Schema.User

  def create_user(name) do
    %User{name: name}
  end

  def create_salary(amount, currency, user_id, active, offset) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(offset)
    |> NaiveDateTime.truncate(:second)
    |> then(
      &%Salary{
        amount: amount,
        currency: currency,
        user_id: user_id,
        active: active,
        inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
        updated_at: &1,
        last_activation_at: DateTime.utc_now()
      }
    )
  end
end
