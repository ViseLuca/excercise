defmodule BeExercise.Entity.Salary do
  @moduledoc """
  Schema for Salaries table
  """

  require Logger

  use Ecto.Schema

  import Ecto.Query

  alias BeExercise.Entity.User
  alias BeExercise.Repo

  @type t :: %__MODULE__{
          amount: String.t(),
          currency: String.t(),
          user_id: integer(),
          active: boolean(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "salaries" do
    field(:amount, :string)
    field(:currency, :string)
    field(:user_id, :integer)
    field(:active, :boolean)

    timestamps()
  end

  @doc """
  Get active or the most recent salaries based on the given parameters.

  ## Parameters
  - `params` (map) - The query parameters including `name` and `orderBy`.

  ## Examples
      iex> __MODULE__.get_active_or_the_most_recent_salaries(%{"name" => "John", "orderBy" => "asc"})
      [%{name: "Luca", amount: "48.000,0", currency: "EUR"}]
  """
  @spec get_active_or_the_most_recent_salaries(map()) :: [t()]
  def get_active_or_the_most_recent_salaries(params) do
    order_by =
      params
      |> Map.get("orderBy", "asc")
      |> String.downcase()
      |> order_by_clause(:name)

    name = Map.get(params, "name", "")

    Repo.all(
      from q in subquery(get_active_or_the_most_recent_salaries_subquery(name)),
        order_by: ^order_by
    )
  end

  defp get_active_or_the_most_recent_salaries_subquery(name) do
    from s in __MODULE__,
      join: u in User,
      on: s.user_id == u.id,
      distinct: [s.user_id],
      where: ilike(u.name, ^"%#{name}%"),
      order_by: [s.user_id, desc: s.active, desc: s.updated_at],
      select: %{name: u.name, amount: s.amount, currency: s.currency}
  end

  defp order_by_clause(clause) when is_tuple(clause), do: clause |> List.wrap() |> Keyword.new()
  defp order_by_clause("asc", column), do: order_by_clause({:asc, column})
  defp order_by_clause("desc", column), do: order_by_clause({:desc, column})

  defp order_by_clause(order_by, column) do
    Logger.warning("#{order_by} is not a valid order_by parameter")
    order_by_clause({:asc, column})
  end
end
