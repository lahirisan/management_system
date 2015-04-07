class SubEstatus < ActiveRecord::Base
  attr_accessible :descripcion
  self.table_name = "sub_estatus"
  self.primary_key = "id" 	

end
