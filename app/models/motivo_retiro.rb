class MotivoRetiro < ActiveRecord::Base
  attr_accessible :descripcion, :habilitado
  self.table_name = "motivo_retiro"
end
