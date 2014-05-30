class Parroquia < ActiveRecord::Base
  self.table_name = "parroquia"
  attr_accessible :habilitado, :id_municipio, :nombre
end
