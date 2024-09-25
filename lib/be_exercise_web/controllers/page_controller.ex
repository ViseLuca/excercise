defmodule BeExerciseWeb.PageController do
  use BeExerciseWeb, :controller

  action_fallback BeExerciseWeb.FallbackController

  def ping(conn, _params) do
    render(conn, :ping)
  end

  def not_found(conn, _params) do
    send_resp(conn, 404, "")
  end
end
