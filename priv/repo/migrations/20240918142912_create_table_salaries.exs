defmodule BeExercise.Repo.Migrations.CreateTableSalaries do
  use Ecto.Migration

  def change do
    create table(:salaries) do
      add(:amount, :bigint, null: false)
      add(:currency, :text, null: false)
      add(:user_id, references(:users, on_delete: :nothing))
      add(:active, :boolean, default: true, null: false)
      add(:last_activation_at, :utc_datetime_usec)

      timestamps()
    end

    create(index(:salaries, :user_id))

    create(index(:salaries, [:active]))

    create unique_index(:salaries, :user_id,
             where: "active = true",
             name: "just_one_active_salary"
           )

    create constraint(:salaries, "amount_cannot_be_negative", check: "amount >= 0")
  end
end
