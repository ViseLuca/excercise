defmodule Unit.BeExercise.Enum.Currencies do
  @moduledoc """
    Test of all available currencies
  """

  use ExUnit.Case, async: true
  @expected_currencies ["EUR", "USD", "JPY", "GBP", "SGD", "AUD"]

  alias BeExercise.Enum.Currencies

  test "Currently all available currencies are #{Kernel.length(@expected_currencies)} and are #{inspect(@expected_currencies)}" do
    available_currencies = Currencies.get()
    assert Kernel.length(@expected_currencies) == Kernel.length(available_currencies)
    assert @expected_currencies == available_currencies
  end

  test "The currency EUR is included in the available_currencies" do
    assert Enum.member?(Currencies.get(), "EUR")
  end

  test "The currency IDR (Indonesian Rupiah) is included in the available_currencies" do
    refute Enum.member?(Currencies.get(), "IDR")
  end
end
