defmodule BeExerciseWeb.EmailControllerTest do
  use BeExerciseWeb.ConnCase, async: true

  import Mock

  alias BeExercise.Entity.Salary
  alias BeExercise.Factory
  alias BeExercise.Repo

  @name "Luca"
  @eur_currency "EUR"

  describe "POST /invite-users" do
    test "check email(s) are sent", %{conn: conn} do
      conn = post(conn, ~p"/invite-users")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert Regex.match?(~r/^\d+ email sent+/, response["message"])
    end

    test "deactivate all the salary and check, no email is sent", %{conn: conn} do
      Repo.update_all(Salary, set: [active: false])

      conn = post(conn, ~p"/invite-users")
      response = Jason.decode!(conn.resp_body)

      assert json_response(conn, 200)
      assert "No email sent" == response["message"]
    end

    test "During the email sending, one or more sending is failing", %{conn: conn} do
      with_mock BEChallengex,
        send_email: fn
          %{name: "Luca"} -> {:error, :econnrefused}
          %{name: name} -> {:ok, name}
        end do
        %{id: id} = Repo.insert!(Factory.create_user(@name))
        Repo.insert!(Factory.create_salary(65_000.0, @eur_currency, id, true))

        conn = post(conn, ~p"/invite-users")
        response = Jason.decode!(conn.resp_body)

        assert Regex.match?(~r/^\d+ email sent+(, \d+ not sent+)*$/, response["message"])
      end
    end
  end
end
