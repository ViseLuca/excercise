defmodule BeExercise.Repo.Migrations.CreateIndexUserIdInSalaryTable do
  use Ecto.Migration

  def change do
    create(index(:salary, :user_id))
  end
end
