defmodule BeExercise.ApiSpec do
  @moduledoc """
        OpenApi module definition to link the router and expose all the api
  """
  alias OpenApiSpex.{Info, OpenApi, Paths}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [],
      info: %Info{
        title: "BeExercise",
        version: "1.0"
      },
      paths: Paths.from_router(BeExerciseWeb.Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
