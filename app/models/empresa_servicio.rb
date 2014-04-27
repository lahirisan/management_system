class EmpresaServicio < ActiveRecord::Base
  attr_accessible :cargo_contacto, :email, :fecha_contratacion, :fecha_finalizacion, :id_servicio, :nombre_contacto, :prefijo, :telefono
  self.table_name = "empresa_servicios"
  belongs_to :servicio, :foreign_key => "id_servicio"
  belongs_to :empresa, :foreign_key => "prefijo"

  	#Eliminar servicios
  	def self.eliminar(parametros)
    
    	#Los servicios se agrega a la tabla empresa_servicios_eliminados y se elimina de empresa_servicios

	    for eliminar_servicio in (0..parametros[:eliminar_servicios].size-1)

	      servicio_seleccionado = parametros[:eliminar_servicios][eliminar_servicio]
	      eliminar_datos = parametros[:"#{servicio_seleccionado}"]
	      id = eliminar_datos.split('_')[0]
	      servicio = EmpresaServicio.find(id) 
	      servicio_eliminado = EmpresaServiciosEliminado.new;
	      servicio_eliminado.prefijo = servicio.prefijo; 
	      servicio_eliminado.id_servicio = servicio.id_servicio; 
	      servicio_eliminado.fecha_contratacion = servicio.fecha_contratacion; 
	      servicio_eliminado.fecha_finalizacion = servicio.fecha_finalizacion;
	      servicio_eliminado.nombre_contacto = servicio.nombre_contacto; 
	      servicio_eliminado.cargo_contacto = servicio.cargo_contacto;
	      servicio_eliminado.telefono = servicio.telefono;
	      servicio_eliminado.email = servicio.email;
	      servicio_eliminado.fecha_eliminacion = Time.now
	      servicio_eliminado.id_subestatus = eliminar_datos.split('_')[2]
	      servicio_eliminado.id_motivo_retiro = eliminar_datos.split('_')[1] 
	      servicio_eliminado.save
	      servicio.destroy

	    end


	end
end

