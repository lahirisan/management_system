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

	      	end


	      }

	    end


	end

end
