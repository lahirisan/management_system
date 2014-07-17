class MunicipiosController < ApplicationController
	
	def index
    	@municipios = Municipio.where("id_estado = ?", params[:id_estado]).order("nombre ASC")
    	respond_to do |format|
      		# JSON que maneja las ciudades dado un esatdo seleccionado
      		format.json { render json: @municipios}
      	end
    end
end
