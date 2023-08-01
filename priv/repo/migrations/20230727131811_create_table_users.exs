defmodule BeExercise.Repo.Migrations.CreateTableUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :text, null: false)

      timestamps()
    end
  end
end
