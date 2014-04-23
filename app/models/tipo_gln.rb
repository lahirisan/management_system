class TipoGln < ActiveRecord::Base
  attr_accessible :habilitado, :nombre
  self.table_name = "tipo_gln"
end
