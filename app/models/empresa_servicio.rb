class EmpresaServicio < ActiveRecord::Base
  attr_accessible :cargo_contacto, :email, :fecha_contratacion, :fecha_finalizacion, :id_servicio, :nombre_contacto, :prefijo, :telefono
  self.table_name = "empresa_servicios"

  belongs_to :servicio, :foreign_key => "id_servicio"
  belongs_to :empresa, :foreign_key => "prefijo"

  validates :id_servicio, :fecha_contratacion,  :fecha_finalizacion,  :nombre_contacto, :cargo_contacto,  :telefono,  :email ,      :presence => {:message => "No puede estar en blanco"}, :on => :create
  validates :email, format: { with: /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/,  :multiline => true, on: :create, :message => "El Formato del correo es invalido"} # Validacion al crear
  validates :telefono, format: { with: /^[0-9]\d*$/, :multiline => true, on: :create, :message => "Solo numeros para el telefono"} # Validacion al crear

  	#Eliminar servicios
  	def self.eliminar(parametros)
    
    	#Los servicios se agrega a la tabla empresa_servicios_eliminados y se elimina de empresa_servicios
      
	    for eliminar_servicio in (0..parametros[:eliminar_servicios].size-1)

	      servicio_seleccionado = parametros[:eliminar_servicios][eliminar_servicio]
	      servicio_ = EmpresaServicio.find(servicio_seleccionado) 
	      servicio_.destroy

	    end


	end

	

end

