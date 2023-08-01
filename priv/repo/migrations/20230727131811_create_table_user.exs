defmodule BeExercise.Repo.Migrations.CreateTableUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add(:name, :text, null: false)

      timestamps()
    end
  end
end
