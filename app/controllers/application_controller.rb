class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def after_sign_up_path_for(user)
    redirect_to root_path
  end

  def after_sign_out_path_for(user)
    request.referrer
  end

  def after_sign_in_path_for(user)
    redirect_to :back
  end



  def require_user
    if current_user.blank?
      respond_to do |format|
        format.html  {
          authenticate_user!
        }
        format.all {
          head(:unauthorized)
        }
      end
    end
  end

end
