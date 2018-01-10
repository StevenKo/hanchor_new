class Admin::SubscriptionsController < Admin::AdminController
  before_action :require_admin

  def index
    @subscriptions = Subscription.paginate(:page => params[:page], :per_page => 30)
  end
end