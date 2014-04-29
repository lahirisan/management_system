class EmpresaServiciosEliminado < ActiveRecord::Base
  attr_accessible :cargo_contacto, :email, :fecha_contratacion, :fecha_finalizacion, :id_servicio, :nombre_contacto, :prefijo, :telefono, :id_motivo_retiro, :id_subestatus
  self.table_name = "empresa_servicios_eliminado"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :servicio, :foreign_key => "id_servicio"
end
