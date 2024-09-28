defmodule BeExercise.OpenApi.Response.User do
  @moduledoc """
        Definition of the response for the Users api
  """
  require OpenApiSpex

  alias BeExercise.OpenApi.Schemas.User, as: UserSchema
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "UserResponse",
    description: "Response schema users",
    type: :object,
    properties: %{
      data: %Schema{title: "Users list", type: :array, items: UserSchema}
    }
  })
end
