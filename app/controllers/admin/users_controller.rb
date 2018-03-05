class Admin::UsersController < Admin::AdminController
  before_action :require_admin

  def index
    @users = User.order("id DESC").paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @user = User.find(params[:id])
  end

  def export
  	attributes = %w{id email name shipping_address phone zip_code city state country}
  	all = User.all
    file = CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end

    respond_to do |format|
      format.html
      format.csv { send_data file, filename: 'Users.csv' }
    end
  end
end
