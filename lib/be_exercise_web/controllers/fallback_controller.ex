defmodule BeExercise.FallbackController do
  use Phoenix.Controller

  def call(conn, _) do
    conn
    |> put_status(:not_found)
    |> put_view(json: BeExerciseWeb.ErrorJSON)
    |> render(:"404")
  end
end
