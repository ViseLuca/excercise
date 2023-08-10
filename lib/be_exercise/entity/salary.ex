defmodule BeExercise.Entity.Salary do
  @moduledoc """
  Schema for Salaries table
  """

  use Ecto.Schema

  alias BeExercise.Entity.User

  @type t :: %__MODULE__{
          amount: float(),
          currency: String.t(),
          user_id: integer(),
          active: boolean(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "salaries" do
    field(:amount, :float)
    field(:currency, :string)
    field(:user_id, :integer)
    field(:active, :boolean)
    belongs_to :users, User

    timestamps()
  end
end
