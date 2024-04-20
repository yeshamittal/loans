# frozen_string_literal: true

class LoansService
  attr_accessor :user_id
  def initialize(user_id)
    @user_id = user_id
  end

  def apply_loan(params)
    LoanRequest.create(params)
    ServiceResponse.success(payload: {}, message: "Request raised successfully")
  end

  def fetch_loans(is_admin = false)
    filters = {}
    if is_admin
      # Fetching only pending loans for admin, which he can approve. This logic can be extended based on usecase
      filters[:status] = LoanRequest::STATUS[:pending]
    else
      # user_id is always checked for customer
      filters[:user_id] = user_id
      filters[:status] = [LoanRequest::STATUS[:approved], LoanRequest::STATUS[:pending], LoanRequest::STATUS[:paid]]
    end

    response = LoanRequest.fetch(filters = filters)
    ServiceResponse.success(payload: response)
  end

  def fetch_loan_details(loan_id)
    response = LoanRequest.fetch_loan_schedules(loan_id = loan_id)
    ServiceResponse.success(payload: response)
  end

  def repay_loan(loan_id, amount)
    loan_request = LoanRequest.find_by(id: loan_id)
    return ServiceResponse.error(payload: {}, message: "Invalid request") if loan_request.blank?
    return ServiceResponse.error(payload: {}, message: "Invalid request") if loan_request.user_id != user_id #loan_id and user_id should match
    return ServiceResponse.error(payload: {}, message: "Loan is not approved") if loan_request.pending?
    return ServiceResponse.error(payload: {}, message: "Loan is already paid") if loan_request.paid?
    #Safety check - Nothing to pay if already paid. Ideally only pending loans should
    # gets requests to repay and is handled on UI

    if loan_request.remaining_amount < amount
      return ServiceResponse.success(payload: {}, message: "Enter amount less than remaining_amount which is #{loan_request.remaining_amount}")
    elsif loan_request.remaining_amount == amount
      loan_request.repay_equal
    else
      # Amount is less than remaining amount
      # If amount is less than schedule payment, raise error
      scheduled_amount = loan_request.latest_installment_amount
      if amount < loan_request.latest_installment_amount
        return ServiceResponse.error(payload: {}, message: "Amount cannot be les than scheduled payment which is #{scheduled_amount}")
      else
        loan_request.repay_more_or_equal_than_scheduled(amount)
        return ServiceResponse.success(payload: {}, message: "Loan repayment successful")
      end
    end
  end

end
