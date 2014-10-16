class EstadosController < ApplicationController
	def show

    	@estado = Estado.find(params[:id])

    	respond_to do |format|
      		
      		format.json { render json: @estado}
      	end

    end
end
