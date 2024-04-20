class RepaymentSchedule < ActiveRecord::Base
  belongs_to :loan_request

  STATUS = {
    pending: 1,
    paid:2,
  }.with_indifferent_access.freeze
  enum status: STATUS

  scope :pending_schedules, lambda { where(status: STATUS[:pending]) }

  class << self
    def create(params)
      schedule = RepaymentSchedule.new(amount: params["amount"], due_date: params["due_date"], loan_request_id: params["loan_request_id"])
      schedule.save
    end

    def repay(schedule_id)
      schedule = RepaymentSchedule.find_by(id: schedule_id)
      return if schedule.blank?

      schedule.status = STATUS["paid"]
      schedule.save
    end

    def update_schedule_amount(loan_id, amount)
      schedules = RepaymentSchedule.pending_schedules.where(loan_request_id: loan_id)
      per_schedule_amount = amount/schedules.size.to_f
      schedules.each do |schedule|
        schedule.amount = (schedule.amount - per_schedule_amount).round(2)
        schedule.save
      end
    end
  end
end
