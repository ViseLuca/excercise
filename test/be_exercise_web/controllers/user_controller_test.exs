defmodule BeExerciseWeb.UserControllerTest do
  use BeExerciseWeb.ConnCase, async: true

  alias BeExercise.Factory
  alias BeExercise.Repo

  @length Application.compile_env!(:be_exercise, :test_rows)
  @name "Luca"
  @eur_currency "EUR"
  @gbp_currency "GBP"

  describe "GET /users" do
    test "check that the length is #{@length} without any filter", %{conn: conn} do
      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert @length == length(response)
    end

    test "check that the response is empty because no name is containing \"Pongolle\" ", %{
      conn: conn
    } do
      conn = get(conn, ~p"/users?name=Pongolle")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert Enum.empty?(response)
    end

    test "check that the response is containing just name containing \"a\" ", %{conn: conn} do
      conn = get(conn, ~p"/users?name=a")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert Enum.all?(response, &String.contains?(&1["name"], "a"))
    end

    test "check that the response is containing just name containing \"a\" and ordered by desc ",
         %{conn: conn} do
      conn = get(conn, ~p"/users?name=a&orderBy=desc")
      response = Jason.decode!(conn.resp_body)

      first_name = response |> List.first() |> Map.get("name")
      last_name = response |> List.last() |> Map.get("name")
      are_name_ordered_desc = first_name > last_name || first_name == last_name

      assert json_response(conn, 200)
      assert Enum.all?(response, &String.contains?(&1["name"], "a"))
      assert are_name_ordered_desc
    end

    test "check that the response is ordered by asc",
         %{conn: conn} do
      conn = get(conn, ~p"/users?orderBy=asc")
      response = Jason.decode!(conn.resp_body)

      first_name = response |> List.first() |> Map.get("name")
      last_name = response |> List.last() |> Map.get("name")
      are_name_ordered_desc = first_name < last_name || first_name == last_name

      assert json_response(conn, 200)
      assert are_name_ordered_desc
    end

    test "check that the response is ordered by asc when a paramerer is not valid",
         %{conn: conn} do
      conn = get(conn, ~p"/users?orderBy=ascendant")
      response = Jason.decode!(conn.resp_body)

      first_name = response |> List.first() |> Map.get("name")
      last_name = response |> List.last() |> Map.get("name")
      are_name_ordered_desc = first_name < last_name || first_name == last_name

      assert json_response(conn, 200)
      assert are_name_ordered_desc
    end

    test "insert one more user with an active salary and check that the length is more than #{@length} and is extracted the active salary",
         %{
           conn: conn
         } do
      %{id: id} = Repo.insert!(Factory.create_user(@name))
      active_amount = 48000.00
      expected_amount = "#{active_amount} #{@eur_currency}"
      Repo.insert!(Factory.create_salary(active_amount, @eur_currency, id, true))
      Repo.insert!(Factory.create_salary(65000.00, @eur_currency, id, false))

      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert @length + 1 == length(response)

      assert %{"name" => @name, "salary" => expected_amount} ==
               extract_row_by_name(response, @name)
    end

    test "insert one more user with a non active salary and check that the length is more than #{@length} and is extracted the last salary",
         %{
           conn: conn
         } do
      %{id: id} = Repo.insert!(Factory.create_user(@name))

      last_amount = 95959.00
      expected_amount = "#{last_amount} #{@gbp_currency}"

      Repo.insert!(Factory.create_salary(19591.00, @eur_currency, id, false))
      Repo.insert!(Factory.create_salary(last_amount, @gbp_currency, id, false, 100))

      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert @length + 1 == length(response)

      assert %{"name" => @name, "salary" => expected_amount} ==
               extract_row_by_name(response, @name)
    end

    test "No user is present in the table",
         %{
           conn: conn
         } do
      Repo.query("TRUNCATE \"salaries\"", [])
      Repo.query("TRUNCATE \"users\"", [])

      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert Enum.empty?(response)
    end
  end

  defp extract_row_by_name(response, name),
    do: response |> Enum.filter(&(&1["name"] == name)) |> List.first()
end
