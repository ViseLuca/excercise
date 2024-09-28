defmodule Unit.BeExercise.Infrastracture.Oban.SendEmailTest do
  @moduledoc false

  use BeExercise.DataCase, async: true
  use Oban.Testing, repo: BeExercise.Repo

  alias BeExercise.Infrastructure.Workers.SendEmail

  describe "Oban job can be executed directly" do
    test "Job is executed directly without being in queue and returning the id of the user" do
      job_response = perform_job(SendEmail, %{name: "Luca", id: 1})

      refute_enqueued(worker: SendEmail, queue: :users_invitations)

      assert {:ok, 1} == job_response
    end
  end
end
