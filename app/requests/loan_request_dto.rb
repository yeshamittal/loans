# frozen_string_literal: true

class LoanRequestDTO
  attr_accessor :amount, :user_id, :term

  def initialize(amount, term, user_id)
    @amount = amount
    @term = term
    @user_id = user_id
  end
end
