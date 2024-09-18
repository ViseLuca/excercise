defmodule BeExerciseWeb.PageControllerTest do
  use BeExerciseWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert json_response(conn, 200)
  end

  test "GET /foo", %{conn: conn} do
    conn = get(conn, ~p"/foo")
    assert 404 == conn.status
  end
end
