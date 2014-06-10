class SessionsController < ApplicationController
	layout "login"
	def new
	end

	def create
	  user = Usuario.authenticate(params[:usuario], params[:clave])
	  if user
	    session[:user_id] = user.id
	    session[:usuario] = user.username
	    session[:perfil] = user.try(:perfil).try(:descripcion)
	    session[:cargo] = user.try(:cargo).try(:descripcion)
	    session[:gerencia] = user.try(:gerencia).try(:nombre)
	    redirect_to empresas_path
	  else
	    flash.now.alert = "Usuario o clave invalido"
	    render "new"
	  end
	end

	def destroy
	  reset_session
	  session[:usuario] = nil
	  session[:user_id] = nil
	  session[:perfil] = nil
	  redirect_to root_path
	end


end
