class EmpresasRetiradas < ActiveRecord::Base
  attr_accessible :fecha_retiro, :id_motivo_retiro, :id_subestatus, :id_usuario, :prefijo
  self.table_name = 'empresas_retiradas'
  belongs_to :empresa, :foreign_key => "prefijo" # Agregar un include con producto para reducir la cantidad de Query generado
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"

end
