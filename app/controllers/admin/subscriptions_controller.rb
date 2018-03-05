class Admin::SubscriptionsController < Admin::AdminController
  before_action :require_admin

  def index
    @subscriptions = Subscription.paginate(:page => params[:page], :per_page => 30)
  end

  def export
  	attributes = %w{id email is_registered}
  	all = Subscription.all
    file = CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data file, filename: 'Subscriptions.csv' }
    end
  end
end