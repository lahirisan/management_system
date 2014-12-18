class SessionsController < ApplicationController
	layout "login"
	def new
	end

	def create
	  user = Usuario.authenticate(params[:usuario], params[:clave])

	  
	  if user
	    session[:user_id] = user.id
	    session[:usuario] = user.nombre_apellido
	    session[:perfil] = user.try(:perfil).try(:descripcion)
	    session[:cargo] = user.try(:cargo).try(:descripcion)
	    session[:gerencia] = user.try(:gerencia).try(:nombre)
	    
	    if session[:gerencia] == 'Comercial'
	    	if session[:perfil] == 'Mercadeo'
	    		redirect_to "/empresa_registradas" 
	    	else
	    		redirect_to "/empresas"
	    	end
	    elsif session[:gerencia] == 'Administracion' 
	    	redirect_to "/empresa_registradas?activar_solvencia=true"
	    else	
	    	redirect_to empresas_path
	    end
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
	  session[:cargo] = nil
	  session[:gerencia] = nil
	  redirect_to root_path
	end


end
