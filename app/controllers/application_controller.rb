class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def admin_only_access
    return unless current_user.admin == false

    flash.alert = 'Admin access only'
    previous_page
  end

  def previous_page
    if request.env['HTTP_REFERER'].nil?
      redirect_to root_path
    else
      redirect_to(request.env['HTTP_REFERER'])
    end
  end
end
