defmodule BeExercise.Fixtures do
  alias BeExercise.Factory
  alias BeExercise.Repo

  def insert_user(name \\ "Luca") do
    name
    |> Factory.create_user()
    |> Repo.insert!()
  end

  def insert_salary(amount, currency, user_id, active, offset \\ 1) do
    amount
    |> Factory.create_salary(currency, user_id, active, offset)
    |> Repo.insert()
  end
end
