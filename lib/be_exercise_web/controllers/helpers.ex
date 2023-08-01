defmodule BeExerciseWeb.Controller.Helpers do
  @moduledoc """
     Common module for controllers to send responses
  """
  import Phoenix.Controller
  import Plug.Conn

  @spec send_response(Plug.Conn.t(), integer(), any()) :: Plug.Conn.t()
  def send_response(conn, status, body) do
    conn
    |> put_status(status)
    |> json(body)
  end
end
