defmodule BeExercise.OpenApi.Schemas.Email do
  @moduledoc """
        Definition of the schema for the Email api
  """
  alias OpenApiSpex.Schema

  @behaviour OpenApiSpex.Schema
  @derive [Jason.Encoder]
  @schema %Schema{
    title: "Email",
    description: "Send email to all the active users",
    type: :object,
    properties: %{},
    required: [:message],
    example: [
      %{
        "message" => "No email sent"
      }
    ]
  }

  def schema, do: @schema
  defstruct Map.keys(@schema.properties)
end
