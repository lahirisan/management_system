class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= Usuario.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_authentication
  	#raise session.to_yaml
    current_user || redirect_to(root_path, :notice => 'El acceso sin session esta restrigido')
  end
  
  helper_method :require_authentication



end
