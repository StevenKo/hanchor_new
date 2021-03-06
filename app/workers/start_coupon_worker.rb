class StartCouponWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(coupon_rule_id)
    @coupon = CouponRule.find(coupon_rule_id)
    @coupon.is_valid = true
    @coupon.save
  end
end