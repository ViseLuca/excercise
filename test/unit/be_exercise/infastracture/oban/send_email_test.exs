defmodule Unit.BeExercise.Infrastracture.Oban.SendEmailTest do
  @moduledoc false

  use BeExercise.DataCase, async: true
  use Oban.Testing, repo: BeExercise.Repo

  alias BeExercise.Infrastructure.Oban.SendEmail

  describe "Oban job can be executed directly" do
    test "Job is executed directly without being in queue" do
      job_response = perform_job(SendEmail, %{})

      refute_enqueued(worker: SendEmail, queue: :users_invitations)

      assert :ok == job_response
    end
  end
end
