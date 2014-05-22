class SessionsController < ApplicationController
	layout "login"
	def new
	end

	def create
	  user = Usuario.authenticate(params[:usuario], params[:clave])
	  if user
	    session[:user_id] = user.id
	    redirect_to empresas_path, :notice => "Logged in"
	  else
	    flash.now.alert = "Invalid email or password"
	    render "new"
	  end
	end

	def destroy
	  session[:user_id] = nil
	  redirect_to 'session/new', :notice => "Logged out!"
	end


end
