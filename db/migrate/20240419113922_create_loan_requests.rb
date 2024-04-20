class CreateLoanRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_requests do |t|
      t.integer :amount
      t.integer :term
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
