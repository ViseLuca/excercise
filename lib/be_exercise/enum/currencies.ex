defmodule BeExercise.Enum.Currencies do
  @moduledoc """
     Enum of all available currencies
  """

  @currencies ~w(EUR USD JPY GBP SGD AUD)

  @spec get() :: [String.t()]
  def get do
    @currencies
  end
end
