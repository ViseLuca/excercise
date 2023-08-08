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
    100_000 * :rand.uniform()
  end

  def create_salary(user_id, active) do
    random_number = :rand.uniform(length(@currencies)) - 1
    currency = @currencies |> List.pop_at(random_number) |> elem(0)

    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(:rand.uniform(1000))
      |> NaiveDateTime.truncate(:second)

    random_float()
    |> Float.round(2)
    |> then(
      &%{
        amount: &1,
        currency: currency,
        user_id: user_id,
        active: active,
        inserted_at: now,
        updated_at: now
      }
    )
  end
end

alias BeExercise.Entity.Salary
alias BeExercise.Entity.User
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
      |> Enum.map(&(i |> Helpers.create_salary(&1)))
      |> Kernel.++(salaries)

    {users, salaries}
  end)

users
|> Enum.chunk_every(1000)
|> Enum.map(&Repo.insert_all(User, &1))

salaries
|> Enum.chunk_every(1000)
|> Enum.map(&Repo.insert_all(Salary, &1))

Logger.debug("End seeding...")
