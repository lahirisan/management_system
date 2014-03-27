class EmpresasRetiradas < ActiveRecord::Base
  attr_accessible :fecha_retiro, :id_motivo_retiro, :id_subestatus, :id_usuario, :prefijo
  self.table_name = 'empresas_retiradas'
  belongs_to :empresa, :foreign_key => "prefijo"
end
