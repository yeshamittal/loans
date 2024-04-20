class LoansAdminController < ApplicationController
  before_action :user_is_admin?

  def fetch_loans
    begin
      service = LoansService.new(user_id = params["user_id"])
      response = service.fetch_loans(is_admin = true)
      render(json: { data: response.payload }, status: response.http_status) and return
    rescue => e
      render(json: {data: nil}, status: 400) and return
    end
  end

  def approve
    begin
      validate_approve_loans_params
      service = LoansAdminService.new(user_id = params["user_id"])
      response = service.approve(loan_id = params["loan_id"])
      render(json: { data: response.payload, message: response.message}, status: response.http_status) and return
    rescue => e
      render(json: {data: nil}, status: 400) and return
    end
  end

  private

  def validate_approve_loans_params
    raise "loan_id is missing" if params["loan_id"].blank?
  end

  # Always checked for all requests
  def user_is_admin?
    raise "Mandatory params are missing" if params.blank?
    raise "User is not Admin" if params["user_id"].blank?
    raise "User is not Admin" unless admin?
  end

  def admin?
    # Assuming that role comes as a parameter
    params["role"] == "admin"
  end
end
