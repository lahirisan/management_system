class Estatus < ActiveRecord::Base
  attr_accessible :alcance, :descripcion, :habilitado
  self.table_name = "estatus"
end
