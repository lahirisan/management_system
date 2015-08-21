module Api
	module V1

		class EmpresasController < ApplicationController

		    respond_to :json  # Unicamente responde a formato JSON
		      
		 		def index
	                
	                render json: (RetirarEmpresasDatatable.new(view_context)) if (params[:retirar] == 'true')
	                
	                render json: (EliminarEmpresasDatatable.new(view_context)) if (params[:eliminar] == 'true')
	                
	                render json: (EmpresasEliminadasDatatable.new(view_context)) if (params[:eliminadas] == 'true')
	                
	                render json: (EmpresasRetiradasDatatable.new(view_context)) if (params[:retiradas] == 'true')
	                
	                render json: (ReactivarEmpresasDatatable.new(view_context)) if (params[:reactivar] == 'true')
	                                                  
	                render json: EmpresasTransferirGtinDatatable.new(view_context) if params[:transferir] == 'true'
	                
		            render json: EmpresasDatatable.new(view_context) if params[:activa] == 'true'
		            

		        end

		end

  	end
end