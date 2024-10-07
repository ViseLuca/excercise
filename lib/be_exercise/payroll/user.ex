defmodule BeExercise.Payroll.User do
  @moduledoc """
      The User context.
  """

  import Ecto.Query

  alias BeExercise.Schema.Salary
  alias BeExercise.Schema.User
  alias BeExercise.Repo

  @doc """
  Get all the users with an active salary
  """
  def get_all_active_users_salaries do
    Repo.all(
      from u in User,
        join: s in Salary,
        on: s.user_id == u.id,
        where: s.active
    )
  end

  @spec create_user(map) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
