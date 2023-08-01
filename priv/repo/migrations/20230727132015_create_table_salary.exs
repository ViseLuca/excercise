defmodule BeExercise.Repo.Migrations.CreateTableSalary do
  use Ecto.Migration

  def change do
    create table(:salary) do
      add(:amount, :text, null: false)
      add(:currency, :text, null: false)
      add(:user_id, references(:user, on_delete: :nothing))
      add(:active, :boolean, default: true, null: false)

      timestamps()
    end
  end
end
