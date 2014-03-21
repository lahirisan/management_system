class Estatus < ActiveRecord::Base
  attr_accessible :descripcion, :habilitado, :id_motivo_retiro, :sub_estatus, :tipo
  self.table_name = "estatus"
end
