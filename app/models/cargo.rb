class Cargo < ActiveRecord::Base
  self.table_name = 'cargo'
  attr_accessible :descripcion, :habilitado
end
