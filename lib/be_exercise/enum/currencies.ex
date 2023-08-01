defmodule BeExercise.Enum.Currencies do
  @moduledoc """
     Enum of all available currencies
  """

  @currencies ~w(EUR USD JPY GBP)

  @spec get() :: [String.t()]
  def get do
    @currencies
  end

  @spec is_currency_available?(String.t()) :: boolean()
  def is_currency_available?(currency) do
    currency
    |> String.upcase()
    |> then(&Enum.member?(@currencies, &1))
  end
end
