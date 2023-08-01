defmodule BeExercise.Repo.Migrations.CreateIndexUserIdInSalariesTable do
  use Ecto.Migration

  def change do
    create(index(:salaries, :user_id))
  end
end
