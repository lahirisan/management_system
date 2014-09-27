class Estado < ActiveRecord::Base
  attr_accessible :habilitado, :id_pais, :nombre
  self.table_name = "estados"
end
