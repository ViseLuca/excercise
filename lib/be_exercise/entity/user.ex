defmodule BeExercise.Entity.User do
  @moduledoc """
  Schema for Users table
  """

  use Ecto.Schema

  import Ecto.Query

  alias BeExercise.Entity.Salary
  alias BeExercise.Repo

  @type t :: %__MODULE__{
          name: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "users" do
    field(:name, :string)

    timestamps()
  end

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
      from u in __MODULE__,
        join: s in Salary,
        on: s.user_id == u.id,
        where: s.active,
        select: u.name
    )
  end
end
