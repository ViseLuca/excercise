defmodule BeExercise.Entity.User do
  @moduledoc """
  Schema for Users table
  """

  use Ecto.Schema

  alias BeExercise.Entity.Salary

  @type t :: %__MODULE__{
          name: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "users" do
    field(:name, :string)
    has_many :salaries, Salary

    timestamps()
  end
end
