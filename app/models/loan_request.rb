class LoanRequest < ActiveRecord::Base

  validates :amount, presence: true
  validates :term, presence: true
  validates :user_id, presence: true

  has_many :repayment_schedules

  STATUS = {
    pending: 1,
    approved: 2,
    paid:3,
  }.with_indifferent_access.freeze
  enum status: STATUS

  def repay_equal
    ActiveRecord::Base.transaction do
      self.status = STATUS[:paid]
      self.remaining_amount = 0
      self.save
      self.repayment_schedules.pending_schedules.update_all(status: RepaymentSchedule::STATUS[:paid])
    end
  end

  def repay_more_or_equal_than_scheduled(amount)
    # Always pay latest schedule
    # If amount is extra, distribute equally to remaining schedules keeping terms constant
    latest_schedule = self.repayment_schedules.pending_schedules.first

    if amount > latest_schedule.amount
      new_remaining_amount = amount - latest_schedule.amount
    else
      new_remaining_amount = latest_schedule.amount - amount
    end
    loan_remaining_amount = self.remaining_amount - amount

    ActiveRecord::Base.transaction do
      RepaymentSchedule.repay(latest_schedule.id)
      self.remaining_amount = loan_remaining_amount.round(2)
      self.status = STATUS[:paid] if loan_remaining_amount == 0
      self.save
      RepaymentSchedule.update_schedule_amount(self.id, new_remaining_amount.round(2)) if new_remaining_amount > 0
    end

  end

  def latest_installment_amount
    self.repayment_schedules.pending_schedules.first.amount
  end



  class << self
    def create(params)
      request = LoanRequest.new(amount: params["amount"], term: params["term"],
                                user_id: params["user_id"], status: STATUS[:pending],
                                remaining_amount: params["amount"])
      request.save
    end

    def fetch(filters)
      loans = LoanRequest.all
      loans = loans.where(status: filters[:status]) if filters[:status].present?
      loans = loans.where(user_id: filters[:user_id]) if filters[:user_id].present?
      loans.order(:created_at).group_by(&:status)
    end

    def fetch_loan_schedules(loan_id)
      return [] if loan_id.blank?
      loan_request = LoanRequest.find_by(id: loan_id)

      return [] if loan_request.blank?
      # Currently fetching all repayment_schedules associated with a loan. This can be changed to only pending/paid based on usecase
      loan_request.repayment_schedules.order(:created_at)
    end

    def approve(loan_id)
      loan_request = LoanRequest.find_by(id: loan_id)
      return if loan_request.blank?
      return if loan_request.approved? #Just a safety check

      # Both the approval process and creation of scheduled payments, should happen together or none at all.
      # This is why they have been kept in a transaction
      ActiveRecord::Base.transaction do
        loan_request.status = STATUS["approved"]
        loan_request.save

        total_terms = loan_request.term
        count = 1
        while count <= total_terms
          RepaymentSchedule.new(amount: (loan_request.amount/total_terms.to_f).round(2),
                                due_date: Time.zone.now+count.week,
                                loan_request_id: loan_request.id,
                                status: RepaymentSchedule::STATUS[:pending]).save
          count+=1
        end
      end
    end

  end

end
