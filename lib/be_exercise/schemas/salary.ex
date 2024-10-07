defmodule BeExercise.Schema.Salary do
  @moduledoc """
  Schema for Salaries table
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias BeExercise.Schema.User

  @type t :: %__MODULE__{
          amount: pos_integer(),
          currency: String.t(),
          user_id: integer(),
          active: boolean(),
          last_activation_at: NaiveDateTime.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "salaries" do
    field(:amount, :integer)
    field(:currency, :string)
    field(:user_id, :integer)
    field(:active, :boolean)
    field(:last_activation_at, :utc_datetime_usec)
    belongs_to :users, User

    timestamps()
  end

  def changeset(salary, attrs) do
    salary
    |> cast(attrs, [:amount, :currency, :active])
    |> validate_required([:amount, :currency, :active])
    |> check_constraint(:amount, name: :amount_cannot_be_negative)
    |> unique_constraint(:user_id,
      name: :just_one_active_salary,
      message: "multiple active salaries are not allowed"
    )
  end
end
