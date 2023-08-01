defmodule Unit.BeExercise.Enum.Currencies do
  @moduledoc """
    Test of all available currencies
  """

  use ExUnit.Case, async: true

  alias BeExercise.Enum.Currencies
  @expected_currencies ~w(EUR USD JPY GBP)

  test "Currently all available currencies are #{Kernel.length(@expected_currencies)} and are #{inspect(@expected_currencies)}" do
    available_currencies = Currencies.get()
    assert Kernel.length(@expected_currencies) == Kernel.length(available_currencies)
    assert @expected_currencies == available_currencies
  end

  test "The currency EUR is included in the available_currencies" do
    assert Currencies.is_currency_available?("EUR")
  end

  test "The currency RP (Indonesian Rupiah) is included in the available_currencies" do
    refute Currencies.is_currency_available?("RP")
  end
end
