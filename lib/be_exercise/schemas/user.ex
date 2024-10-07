defmodule BeExercise.Schema.User do
  @moduledoc """
  Schema for Users table
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias BeExercise.Schema.Salary

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

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
