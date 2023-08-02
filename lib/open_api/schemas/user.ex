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
      salary: %Schema{type: :string, description: "Salary amount and currency"}
    },
    required: [:name, :salary],
    example: [
      %{
        "name" => "Joe",
        "salary" => "30000.0 EUR"
      }
    ]
  }

  def schema, do: @schema
  defstruct Map.keys(@schema.properties)
end
