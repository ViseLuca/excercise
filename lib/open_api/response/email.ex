defmodule BeExercise.OpenApi.Response.Email do
  @moduledoc """
        Definition of the response for Email api
  """
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "EmailResponse",
    description: "Response schema email",
    type: :string,
    example: "Job scheduled"
  })
end
