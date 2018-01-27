class Admin::AnnouncementsController < Admin::AdminController

  def index
    @announcements = Announcement.paginate(:page => params[:page], :per_page => 20)
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def new
    @announcement = Announcement.new
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_param)
      flash[:notice] = "Update success"
    else
      flash[:error] = "Update fail!"
    end
    redirect_to edit_admin_announcement_path(@announcement)
  end

  def create
    @announcement = Announcement.new(announcement_param)
    if @announcement.save
      flash[:notice] = "Create success"      
    else
      flash[:error] = "Create fail!"
    end
    redirect_to edit_admin_announcement_path(@announcement)
  end

  def destroy
    Announcement.delete(params[:id])
    flash[:notice] = "delete success"
    redirect_to admin_announcements_path
  end

private
  def announcement_param
    params.require(:announcement).permit(:message,:message_en,:link,:sort)
  end

end
