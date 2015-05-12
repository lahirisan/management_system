class Municipio < ActiveRecord::Base
  self.table_name = "municipio"
  attr_accessible :ciudad_sede, :habilitado, :id_estado, :nombre
  belongs_to :estado, :foreign_key =>  "id_estado"
end
