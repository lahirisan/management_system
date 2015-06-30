class ReportesController < ApplicationController
	def index

    	# OJO: La llamada JSON y los parametro se establecen en el datatable desde el template.html.haml
	    
	    respond_to do |format|
	      format.html{

	                if params[:reporte_empresa]

	                	render :template =>'/reportes/reporte_empresa.html.haml'

	               	elsif params[:reporte_producto]
	               		
                      render :template => "/reportes/reporte_producto.html.haml"

                    elsif params[:reporte_gln]
						
						render :template => "/reportes/reporte_gln.html.haml" 

					elsif params[:reporte_servicio] 
						
						render :template => "/reportes/reporte_servicios.html.haml"

	               	end

	      } # index.html.erb

	      format.json{

	      	if params[:reporte_empresa] == 'true'

                 render json: ReporteEmpresasDatatable.new(view_context)
             
            elsif params[:reporte_producto] == 'true'

                render json: ReporteProductosDatatable.new(view_context)

            elsif params[:reporte_gln] == 'true'

				render json: ReporteGlnDatatable.new(view_context)            	

			elsif params[:reporte_servicio] == 'true'

				render json: ReporteServicioDatatable.new(view_context)            	

            end 


	      }

	      format.pdf{


	      	if params[:reporte_producto]

                pdf = ReporteProductosPdf.new(params[:nombre_empresa], params[:prefijo],params[:tipo_gtin], params[:gtin], params[:descripcion], params[:marca], params[:codigo_producto], params[:fecha_creacion], params[:fecha_modificacion], params[:estatus], params[:filtro_general])
                send_data pdf.render, filename: "reporte_productos_#{Time.now}.pdf", type: "application/pdf", disposition: "inline"

            end 

	      }

	      format.xlsx{

	      	if params[:reporte_producto]

            	render :template => "/reportes/reporte_producto.xlsx.axlsx"

	      	elsif params[:reporte_gln]
	      		
	      		render :template => "/reportes/reporte_gln.xlsx.axlsx"

	      	elsif params[:reporte_servicio]
				
				render :template => "/reportes/reporte_servicio.xlsx.axlsx"

			elsif params[:listado_gepir]
				render :template => "/reportes/listado_gepir.xlsx.axlsx"

			elsif params[:reporte_empresas]

				render :template => "/reportes/reporte_empresas.xlsx.axlsx"
								
	      	end


	      }

	      	# Exportar CSV según formato de auditoria Service Retail

	      	format.csv{
	      		
	      		if params[:exportar_csv_auditoria_service_retail_empresas]
	      			send_data Empresa.csv_auditoria_service_retail_empresa, :filename => "csv_auditoria_service_retail_empresa.csv"
	      		elsif params[:exportar_csv_auditoria_service_retail_gln]
	      			send_data Gln.csv_auditoria_service_retail_gln, :filename => "csv_auditoria_service_retail_gln.csv"
	      		elsif params[:exportar_csv_auditoria_service_retail_productos]
	      			send_data Producto.csv_auditoria_service_retail_producto, :filename => "csv_auditoria_service_retail_producto.csv"

	      		end

	      	}

	    end

	end

end
