defmodule BeExerciseWeb.FallbackController do
  @moduledoc """
  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BeExerciseWeb, :controller

  def call(conn, _) do
    conn
    |> put_status(:not_found)
    |> put_view(json: BeExerciseWeb.ErrorJSON)
    |> render(:"404")
  end
end
