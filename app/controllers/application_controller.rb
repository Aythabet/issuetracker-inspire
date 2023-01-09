class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def admin_only_access
    if current_user.admin == false ;
      flash.alert = "Admin access only"
      redirect_to(request.env['HTTP_REFERER'])
    end
  end

  def previous_page
    redirect_to(request.env['HTTP_REFERER'])
  end


end
