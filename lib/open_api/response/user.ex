defmodule BeExercise.OpenApi.Response.User do
  @moduledoc """
        Definition of the response for the Users api
  """
  require OpenApiSpex
  alias BeExercise.OpenApi.Schemas.User, as: UserSchema

  OpenApiSpex.schema(%{
    title: "UserResponse",
    description: "Response schema users",
    type: :object,
    properties: %{
      data: UserSchema
    }
  })
end
