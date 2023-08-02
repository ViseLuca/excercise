defmodule BeExercise.OpenApi.Response.Email do
  @moduledoc """
        Definition of the response for Email api
  """
  require OpenApiSpex
  alias BeExercise.OpenApi.Schemas.Email, as: EmailSchema

  OpenApiSpex.schema(%{
    title: "EmailResponse",
    description: "Response schema email",
    type: :object,
    properties: %{
      data: EmailSchema
    }
  })
end
