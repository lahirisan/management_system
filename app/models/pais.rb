class Pais < ActiveRecord::Base
  self.table_name = "pais"
  attr_accessible :habilitado, :nombre

end
