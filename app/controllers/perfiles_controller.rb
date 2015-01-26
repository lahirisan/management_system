class PerfilesController < ApplicationController
	def index
    	@perfiles = Perfil.where("id_gerencia = ?", params[:id_gerencia]).order("descripcion ASC")
    	respond_to do |format|
      		# JSON que maneja las ciudades dado un esatdo seleccionado
      		format.json { render json: @perfiles}
      	end
    end

end
