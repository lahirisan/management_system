class SessionsController < ApplicationController
	layout "login"
	def new
	end

	def create
	  user = Usuario.authenticate(params[:usuario], params[:clave])
	  if user
	    session[:user_id] = user.id
	    redirect_to empresas_path
	  else
	    flash.now.alert = "Usuario o clave invalido"
	    render "new"
	  end
	end

	def destroy
	  reset_session
	  session[:user_id] = nil
	  redirect_to root_path
	end


end
