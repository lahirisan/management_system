class Gerencia < ActiveRecord::Base
  self.table_name = "gerencias"
  attr_accessible :habilitado, :nombre
end
