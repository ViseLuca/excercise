defmodule BeExercise.OpenApi.Schemas.User do
  @moduledoc """
        Definition of the schema for the Users api
  """

  alias OpenApiSpex.Schema
  @behaviour OpenApiSpex.Schema
  @derive [Jason.Encoder]
  @schema %Schema{
    title: "User",
    description: "Users in the application",
    type: :object,
    properties: %{
      name: %Schema{type: :string, description: "User name"},
      salary: %Schema{type: :integer, description: "Salary amount"},
      currency: %Schema{type: :string, description: "Salary currency"}
    },
    required: [:name, :salary, :currency],
    example: %{
      "name" => "Joe",
      "salary" => 3_000_000,
      "currency" => "EUR"
    }
  }

  def schema, do: @schema
  defstruct Map.keys(@schema.properties)
end
