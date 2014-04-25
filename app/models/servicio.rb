class Servicio < ActiveRecord::Base
  attr_accessible :habilitado, :nombre
  self.table_name = "servicios"
  has_many :empresa_servicios
end
