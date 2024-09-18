defmodule BeExerciseWeb.EmailControllerTest do
  use BeExerciseWeb.ConnCase, async: true

  import Mock
  import OpenApiSpex.TestAssertions

  alias BeExercise.Entity.Salary
  alias BeExercise.Fixtures
  alias BeExercise.Repo

  @name "Luca"
  @eur_currency "EUR"

  describe "POST /invite-users" do
    test "check email(s) are sent", %{conn: conn} do
      conn = post(conn, ~p"/invite-users")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()

      assert json_response(conn, 200)
      assert Regex.match?(~r/^\d+ email sent+/, response["data"]["message"])
      assert_schema(response, "EmailResponse", api_spec)
    end

    test "deactivate all the salary and check, no email is sent", %{conn: conn} do
      Repo.update_all(Salary, set: [active: false])

      conn = post(conn, ~p"/invite-users")
      response = Jason.decode!(conn.resp_body)
      api_spec = BeExercise.ApiSpec.spec()

      assert json_response(conn, 200)
      assert "No email sent" == response["data"]["message"]
      assert_schema(response, "EmailResponse", api_spec)
    end

    test "During the email sending, one or more sending is failing", %{conn: conn} do
      with_mock BEChallengex,
        send_email: fn
          %{name: "Luca"} -> {:error, :econnrefused}
          %{name: name} -> {:ok, name}
        end do
        %{id: id} = Fixtures.insert_user(@name)
        Fixtures.insert_salary(6_500_000, @eur_currency, id, true)

        api_spec = BeExercise.ApiSpec.spec()
        conn = post(conn, ~p"/invite-users")
        response = Jason.decode!(conn.resp_body)

        assert Regex.match?(~r/^\d+ email sent+(, \d+ not sent+)*$/, response["data"]["message"])
        assert_schema(response, "EmailResponse", api_spec)
      end
    end
  end
end
