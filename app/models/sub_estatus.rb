class SubEstatus < ActiveRecord::Base
  attr_accessible :descripcion
  self.table_name = "sub_estatus"
  set_primary_key "id" 	

end
