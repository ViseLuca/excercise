defmodule BeExerciseWeb.UserControllerTest do
  use BeExerciseWeb.ConnCase, async: true

  import OpenApiSpex.TestAssertions

  alias BeExercise.Fixtures
  alias BeExercise.Repo

  @length Application.compile_env!(:be_exercise, :test_rows)
  @name "Luca"
  @eur_currency "EUR"
  @gbp_currency "GBP"

  describe "GET /users" do
    test "check that the length is #{@length} without any filter", %{conn: conn} do
      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()

      assert json_response(conn, 200)
      assert @length == length(response["data"])
      assert_schema(response, "UserResponse", api_spec)
    end

    test "check that the response is empty because no name is containing \"Pongolle\" ", %{
      conn: conn
    } do
      conn = get(conn, ~p"/users?name=Pongolle")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()
      data = response["data"]

      assert json_response(conn, 200)
      assert Enum.empty?(data)
      assert_schema(response, "UserResponse", api_spec)
    end

    test "filters users regardless of the name query being upper or lower case and ordered by desc ",
         %{conn: conn} do
      _user = Fixtures.insert_user("davide")

      search_param = "d"
      conn = get(conn, ~p"/users?name=#{search_param}&orderBy=desc")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()
      data = response["data"]

      first_name = data |> List.first() |> Map.get("name")
      last_name = data |> List.last() |> Map.get("name")
      are_name_ordered_desc = first_name > last_name || first_name == last_name

      assert json_response(conn, 200)

      assert Enum.all?(
               data,
               &(&1["name"] |> String.downcase() |> String.starts_with?(search_param))
             )

      assert are_name_ordered_desc
      assert_schema(response, "UserResponse", api_spec)
    end

    test "check that the response is ordered by asc",
         %{conn: conn} do
      conn = get(conn, ~p"/users?orderBy=asc")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()
      data = response["data"]

      first_name = data |> List.first() |> Map.get("name")
      last_name = data |> List.last() |> Map.get("name")
      are_name_ordered_desc = first_name < last_name || first_name == last_name

      assert json_response(conn, 200)
      assert are_name_ordered_desc
      assert_schema(response, "UserResponse", api_spec)
    end

    test "check that the response is ordered by asc when a parameter is not valid",
         %{conn: conn} do
      conn = get(conn, ~p"/users?orderBy=descendant")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()

      assert json_response(conn, 422)
      assert_schema(response, "UserResponse", api_spec)
    end

    test "insert one more user with an active salary and check that the length is more than #{@length} and is extracted the active salary",
         %{
           conn: conn
         } do
      %{id: id} = Fixtures.insert_user(@name)
      expected_amount = 4_800_000
      Fixtures.insert_salary(expected_amount, @eur_currency, id, true)
      Fixtures.insert_salary(6_500_000, @eur_currency, id, false)

      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()
      data = response["data"]

      assert json_response(conn, 200)
      assert @length + 1 == length(data)

      assert %{"name" => @name, "salary" => expected_amount, "currency" => @eur_currency} ==
               extract_row_by_name(data, @name)

      assert_schema(response, "UserResponse", api_spec)
    end

    test "insert one more user with a non active salary and check that the length is more than #{@length} and is extracted the last salary",
         %{
           conn: conn
         } do
      %{id: id} = Fixtures.insert_user(@name)
      api_spec = BeExercise.ApiSpec.spec()
      expected_amount = 9_595_900

      Fixtures.insert_salary(1_959_100, @eur_currency, id, false)
      Fixtures.insert_salary(expected_amount, @gbp_currency, id, false, 100)

      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)
      data = response["data"]

      assert json_response(conn, 200)
      assert @length + 1 == length(data)

      assert %{"name" => @name, "salary" => expected_amount, "currency" => @gbp_currency} ==
               extract_row_by_name(data, @name)

      assert_schema(response, "UserResponse", api_spec)
    end

    test "No user is present in the table",
         %{
           conn: conn
         } do
      Repo.query("TRUNCATE \"salaries\"", [])
      Repo.query("TRUNCATE \"users\"", [])

      conn = get(conn, ~p"/users")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()

      assert json_response(conn, 200)
      assert Enum.empty?(response["data"])
      assert_schema(response, "UserResponse", api_spec)
    end
  end

  defp extract_row_by_name(response, name),
    do: response |> Enum.filter(&(&1["name"] == name)) |> List.first()
end
