# frozen_string_literal: true

class LoansAdminService
  attr_accessor :user_id
  def initialize(user_id)
    @user_id = user_id
  end

  def approve(loan_id)
    LoanRequest.approve(loan_id)
    ServiceResponse.success(payload: {}, message: "Approved")
  end
end
