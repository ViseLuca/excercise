defmodule BeExercise.Context.User do
  @moduledoc """
      The User context.
  """

  import Ecto.Query

  alias BeExercise.Entity.Salary
  alias BeExercise.Entity.User
  alias BeExercise.Repo

  @doc """
  Get all the current active users

  ## Parameters
      No parameter is needed for this fn

  ## Examples
      iex> __MODULE__.get_all_active_users()
      ["Luca", "Marco", "Sinama"]
  """
  def get_all_active_users do
    Repo.all(
      from u in User,
        join: s in Salary,
        on: s.user_id == u.id,
        where: s.active,
        select: u.name
    )
  end
end
