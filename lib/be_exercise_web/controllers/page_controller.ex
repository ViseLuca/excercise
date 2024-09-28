defmodule BeExerciseWeb.PageController do
  @moduledoc false

  use BeExerciseWeb, :controller

  action_fallback BeExerciseWeb.FallbackController

  def ping(conn, _params) do
    render(conn, :ping)
  end
end
