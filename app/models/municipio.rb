class Municipio < ActiveRecord::Base
  self.table_name = "municipio"
  attr_accessible :ciudad_sede, :habilitado, :id_estado, :nombre
end
