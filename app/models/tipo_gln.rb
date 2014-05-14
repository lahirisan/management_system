class TipoGln < ActiveRecord::Base
  attr_accessible :habilitado, :nombre
  self.table_name = "tipo_gln"
  has_many :gln, :foreign_key => "tipo_gln"
end
