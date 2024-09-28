defmodule BeExercise.Repo.Migrations.AddObanTables do
  use Ecto.Migration

  def change do
    Oban.Migration.up(version: 12)
  end
end
