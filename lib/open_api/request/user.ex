defmodule BeExercise.OpenApi.Request.User do
  @moduledoc """
        Definition of the response for the Users api
  """
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "UserRequest",
    description: "Schema di validazione per i parametri di query dell'utente",
    type: :object,
    properties: %{
      name: %Schema{type: :string, description: "Nome per la ricerca", minLength: 1},
      orderBy: %Schema{
        type: :string,
        description: "Ordina per",
        enum: ["ASC", "DESC"],
        default: "ASC"
      }
    },
    required: [:name],
    additionalProperties: false
  })
end
