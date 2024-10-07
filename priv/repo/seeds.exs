# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BeExercise.Repo.insert!(%BeExercise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Helpers do
  alias BeExercise.Enum.Currencies

  @currencies Currencies.get()

  def create_user(name) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
    |> then(&%{name: name, inserted_at: &1, updated_at: &1})
  end

  defp random_float() do
    10_000_000 * :rand.uniform()
  end

  def create_salary(user_id, active) do
    random_number = :rand.uniform(length(@currencies)) - 1
    currency = @currencies |> List.pop_at(random_number) |> elem(0)

    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(:rand.uniform(1000))
      |> NaiveDateTime.truncate(:second)

    last_activation_at = if active, do: DateTime.utc_now(), else: nil

    random_float()
    |> trunc()
    |> then(
      &%{
        amount: &1,
        currency: currency,
        user_id: user_id,
        active: active,
        inserted_at: now,
        updated_at: now,
        last_activation_at: last_activation_at
      }
    )
  end
end

alias BeExercise.Schema.Salary
alias BeExercise.Schema.User
alias BeExercise.Enum.Currencies
alias BeExercise.Repo

require Logger

expected_rows = Application.compile_env!(:be_exercise, :test_rows)

names = BEChallengex.list_names()

Logger.debug("Start seeding...")

{users, salaries} =
  Enum.reduce(1..expected_rows, {[], []}, fn i, {users, salaries} ->
    users =
      names
      |> List.pop_at(rem(i, length(names)))
      |> elem(0)
      |> Helpers.create_user()
      |> List.wrap()
      |> Kernel.++(users)

    salaries =
      i
      |> :rand.uniform()
      |> rem(3)
      |> case do
        0 -> [true, false]
        1 -> [false, true]
        2 -> [false, false]
      end
      |> Enum.map(&Helpers.create_salary(i, &1))
      |> Kernel.++(salaries)

    {users, salaries}
  end)

users
|> Enum.chunk_every(5000)
|> Enum.map(&Repo.insert_all(User, &1))

salaries
|> Enum.map(
  &%{
    amount: &1.amount,
    currency: &1.currency,
    user_id: &1.user_id,
    active: &1.active,
    inserted_at: &1.inserted_at,
    updated_at: &1.updated_at,
    last_activation_at: &1.last_activation_at
  }
)
|> Enum.chunk_every(5000)
|> Enum.map(&Salary.create_salary(Salary, &1))
|> Enum.reduce([], fn
  {_, nil}, acc -> acc
  {_, error}, acc -> acc ++ [error]
end)
|> case do
  [] -> "All salaries inserted"
  errors -> "Error while inserting salaries #{errors}"
end

Logger.debug("End seeding...")
