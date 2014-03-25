class SubEstatus < ActiveRecord::Base
  attr_accessible :descripcion, :habilitado
  self.table_name = "sub_estatus"
end
