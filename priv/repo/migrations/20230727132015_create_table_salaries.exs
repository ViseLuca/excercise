defmodule BeExercise.Repo.Migrations.CreateTableSalaries do
  use Ecto.Migration

  def change do
    create table(:salaries) do
      add(:amount, :float, null: false)
      add(:currency, :text, null: false)
      add(:user_id, references(:users, on_delete: :nothing))
      add(:active, :boolean, default: true, null: false)

      timestamps()
    end
  end
end
