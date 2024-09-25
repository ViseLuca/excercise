defmodule BeExercise.Context.Salary do
  @moduledoc """
      The Salary context.
  """

  require Logger

  use Ecto.Schema

  alias BeExercise.Repo
  alias Ecto.Adapters.SQL

  @doc """
  Get active or the most recent salaries based on the given parameters.

  ## Parameters
  - `params` (map) - The query parameters including `name` and `orderBy`.

  ## Examples
      iex> __MODULE__.get_active_or_the_most_recent_salaries(%{"name" => "Luca", "orderBy" => "asc"})
      [["Luca", 4800000, "EUR"]]
  """

  @type salary_response() :: list(String.t() | pos_integer())

  @spec get_active_or_the_most_recent_salaries(map()) :: [salary_response()]
  def get_active_or_the_most_recent_salaries(params) do
    order_by =
      params
      |> Map.get("orderBy", "ASC")
      |> String.upcase()
      |> order_by_clause()

    params
    |> Map.get("name", "")
    |> get_active_or_the_most_recent_salaries_subquery(order_by)
    |> then(& &1.rows)
  end

  defp get_active_or_the_most_recent_salaries_subquery(name, order_by) do
    SQL.query!(Repo, "WITH ActiveOrMostActiveSalaries AS (
  SELECT
    s.user_id,
    u.name,
    s.amount,
    s.currency,
    s.active,
    s.last_activation_at,
    ROW_NUMBER() OVER (
      PARTITION BY s.user_id
      ORDER BY s.active DESC, s.last_activation_at DESC
    ) AS rn
  FROM salaries s
  JOIN users u ON s.user_id = u.id
  WHERE name ilike '#{name}%'
)
SELECT
  name,
  amount,
  currency
FROM ActiveOrMostActiveSalaries
WHERE rn = 1
ORDER BY name #{order_by};")
  end

  defp order_by_clause(clause) when clause in ["ASC", "DESC"], do: clause

  defp order_by_clause(clause) do
    Logger.warning("#{clause} is not a valid order_by parameter")
    "ASC"
  end
end
