class AddRemainingAmountLoanRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_requests, :remaining_amount, :float
  end
end
