class DiscountRule < ActiveRecord::Base
  require 'sidekiq/api'
  after_update :check_date_job
  after_create :check_date_job

  has_many :discount_products
  has_many :discount_records

  DISCOUNT_TYPE = ["cash", "percentage", "free_shipping"]

  scope :active, -> { where("? >= start_date AND ? < end_date", Time.now, Time.now) }

  validates :code, uniqueness: true

  def check_date_job
    if saved_change_to_attribute?(:start_date)
      if start_date_job_id.present?
        scheduled_job = Sidekiq::ScheduledSet.new
        scheduled_job.each do |job|
          if job.jid == start_date_job_id
            job.delete
          end
        end
      end

      if Time.now < start_date
        self.update_column(:is_valid, false)
        start_job_id = StartCouponWorker.perform_at(start_date, id)
        self.update_column(:start_date_job_id, start_job_id)
      else
        self.update_column(:is_valid, true)
      end
    end

    if saved_change_to_attribute?(:end_date)
      if end_date_job_id.present?
        scheduled_job = Sidekiq::ScheduledSet.new
        scheduled_job.each do |job|
          if job.jid == end_date_job_id
            job.delete
          end
        end
      end
      if Time.now > end_date
        self.update_column(:is_valid, false)
      else
        end_job_id = StopCouponWorker.perform_at(end_date, id)
        self.update_column(:end_date_job_id, end_job_id)
      end
    end
  end

end
