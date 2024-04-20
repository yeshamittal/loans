class CreateRepaymentSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :repayment_schedules do |t|
      t.integer :amount
      t.timestamp :due_date
      t.references :loan_request, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
