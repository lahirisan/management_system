class EmpresaServicio < ActiveRecord::Base
  attr_accessible :cargo_contacto, :email, :fecha_contratacion, :fecha_finalizacion, :id_servicio, :nombre_contacto, :prefijo, :telefono
  self.table_name = "empresa_servicios"
  belongs_to :servicio, :foreign_key => "id"
  belongs_to :empresa, :foreign_key => "prefijo"
end
