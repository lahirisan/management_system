class Ciudad < ActiveRecord::Base
  attr_accessible :habilitado, :id_estado, :nombre
  self.table_name = "ciudad"
  belongs_to :estado, :foreign_key =>  "id_estado"
end
