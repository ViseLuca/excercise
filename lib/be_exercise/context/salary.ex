defmodule BeExercise.Context.Salary do
  @moduledoc """
      The Salary context.
  """

  require Logger

  use Ecto.Schema

  import Ecto.Query

  alias BeExercise.Entity.Salary
  alias BeExercise.Entity.User
  alias BeExercise.Repo

  @doc """
  Get active or the most recent salaries based on the given parameters.

  ## Parameters
  - `params` (map) - The query parameters including `name` and `orderBy`.

  ## Examples
      iex> __MODULE__.get_active_or_the_most_recent_salaries(%{"name" => "Luca", "orderBy" => "asc"})
      [%{name: "Luca", amount: 4800000, currency: "EUR"}]
  """
  @spec get_active_or_the_most_recent_salaries(map()) :: [Salary.t()]
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
    from s in Salary,
      join: u in User,
      on: s.user_id == u.id,
      distinct: [s.user_id],
      where: ilike(u.name, ^"#{name}%"),
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
