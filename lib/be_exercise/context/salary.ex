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
      [%{name: "Luca", salary: 4800000, currency: "EUR"}]
  """

  @type salary_response() :: list(String.t() | pos_integer())
  @type salary_request() :: %{
          name: String.t(),
          orderBy: String.t()
        }

  @spec get_active_or_the_most_recent_salaries(salary_request()) :: [salary_response()]
  def get_active_or_the_most_recent_salaries(params) do
    order_by =
      order_by_clause(params[:orderBy], :name)

    get_active_or_the_most_recent_salaries_subquery(params[:name], order_by)
  end

  defp get_active_or_the_most_recent_salaries_subquery(name, order_by) do
    subquery =
      from(s in Salary,
        join: u in User,
        on: s.user_id == u.id,
        where: ilike(u.name, ^"#{name}%"),
        select: %{
          user_id: s.user_id,
          name: u.name,
          amount: s.amount,
          currency: s.currency,
          active: s.active,
          last_activation_at: s.last_activation_at,
          rn:
            fragment(
              "ROW_NUMBER() OVER (PARTITION BY ? ORDER BY ? DESC, ? DESC)",
              s.user_id,
              s.active,
              s.last_activation_at
            )
        }
      )

    query =
      from(salaries in subquery(subquery),
        where: salaries.rn == 1,
        order_by: ^order_by,
        select: %{
          name: salaries.name,
          amount: salaries.amount,
          currency: salaries.currency
        }
      )

    Repo.all(query)
  end

  defp order_by_clause(clause) when is_tuple(clause), do: clause |> List.wrap() |> Keyword.new()

  defp order_by_clause(order_by, column) when order_by in ["ASC", "asc", "DESC", "desc"],
    do:
      order_by
      |> String.downcase()
      |> String.to_existing_atom()
      |> then(&{&1, column})
      |> order_by_clause()

  defp order_by_clause(nil, column), do: {:asc, column}
end
