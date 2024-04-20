class LoanRequestsController < ApplicationController
  before_action :mandatory_params_present?

  # Apply for loans
  def apply
    begin
      validate_apply_params(params)
      service = LoansService.new(user_id = params["user_id"])
      response = service.apply_loan(params)
      render(json: { data: response.payload, message: response.message }, status: response.http_status) and return
    rescue => e
      # Specific errors can be handled here.
      render(json: {data: nil}, status: 400) and return
    end
  end

  # Fetch loan requests created by customer - all: pending, approved and paid requests are fetched
  def fetch_loan
    begin
      service = LoansService.new(user_id = params["user_id"])
      response = service.fetch_loans
      render(json: { data: response.payload }, status: response.http_status) and return
    rescue => e
      render(json: {data: nil}, status: 400) and return
    end
  end

  # Fetches loan details which includes repayment schedules
  def details
    begin
      validate_loan_details_params
      service = LoansService.new(user_id = params["user_id"])
      response = service.fetch_loan_details(loan_id = params["loan_id"])
      render(json: { data: response.payload }, status: response.http_status) and return
    rescue => e
      render(json: {data: nil}, status: 400) and return
    end
  end

  # Repay loan with a specfic amount
  def repay
    begin
      validate_repay_loan_params
      service = LoansService.new(user_id = params["user_id"])
      response = service.repay_loan(loan_id = params["loan_id"], amount = params["amount"])
      render(json: { data: response.payload, message: response.message }, status: response.http_status) and return
    rescue => e
      render(json: {data: nil}, status: 400) and return
    end
  end


  private

  # User and params mandatory validation
  def mandatory_params_present?
    raise "Mandatory params are missing" if params.blank?
    raise "User details are missing" if params["user_id"].blank?
  end

  def validate_apply_params(params)
    raise "Loan amount is missing" if params["amount"].blank?
    raise "Loan term is missing" if params["term"].blank?
  end

  def validate_loan_details_params
    raise "Loan details are missing" if params["loan_id"].blank?
  end

  def validate_repay_loan_params
    raise "Loan details are missing" if params["loan_id"].blank?
    raise "Amount is missing" if params["amount"].blank?
  end

end
