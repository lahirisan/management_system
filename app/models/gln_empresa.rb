class GlnEmpresa < ActiveRecord::Base
  attr_accessible :gln, :prefijo
  self.table_name = "gln_empresa"
  belongs_to :empresa, :foreign_key => "prefijo"
end
