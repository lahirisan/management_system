class EmpresaServiciosEliminado < ActiveRecord::Base
  attr_accessible :cargo_contacto, :email, :fecha_contratacion, :fecha_finalizacion, :id_servicio, :nombre_contacto, :prefijo, :telefono, :id_motivo_retiro, :id_subestatus
  self.table_name = "empresa_servicios_eliminado"
end
