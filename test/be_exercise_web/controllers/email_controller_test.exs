defmodule BeExerciseWeb.EmailControllerTest do
  use BeExerciseWeb.ConnCase, async: true
  use Oban.Testing, repo: BeExercise.Repo

  alias BeExercise.Infrastructure.Workers.SendEmail

  describe "POST /invite-users" do
    test "email job is successfully scheduled", %{conn: conn} do
      conn = post(conn, ~p"/invite-users")

      assert 202 == conn.status
      assert_enqueued(worker: SendEmail, queue: :users_invitations)
    end
  end
end
