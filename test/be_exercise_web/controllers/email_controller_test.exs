defmodule BeExerciseWeb.EmailControllerTest do
  use BeExerciseWeb.ConnCase, async: true
  use Oban.Testing, repo: BeExercise.Repo

  import Mock

  alias BeExercise.Infrastructure.Workers.SendEmail

  describe "POST /invite-users" do
    test "email job is successfully scheduled", %{conn: conn} do
      conn = post(conn, ~p"/invite-users")

      assert 202 == conn.status
      assert_enqueued(worker: SendEmail, queue: :users_invitations)
    end

    test "email jobs are not scheduled due to database error", %{conn: conn} do
      with_mock Oban, insert_all: fn _ -> {:error, %Ecto.Changeset{}} end do
        _conn = post(conn, ~p"/invite-users")

        refute_enqueued(worker: SendEmail, queue: :users_invitations)
      end
    end
  end
end
