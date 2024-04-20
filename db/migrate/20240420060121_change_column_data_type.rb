class ChangeColumnDataType < ActiveRecord::Migration[7.0]
  def change
    change_column(:loan_requests, :amount, :float)
    change_column(:repayment_schedules, :amount, :float)
  end
end
