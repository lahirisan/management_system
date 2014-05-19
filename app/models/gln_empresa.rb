class GlnEmpresa < ActiveRecord::Base
  attr_accessible :id_gln, :prefijo
  self.table_name = "gln_empresa"
  belongs_to :empresa, :foreign_key => "prefijo"
  belongs_to :empresa_eliminada, :foreign_key => "prefijo"
  belongs_to :gln, :foreign_key => "id_gln"
  belongs_to :gln_eliminado, :foreign_key => "id_gln"  
  validates :id_gln, :uniqueness => {:scope => :prefijo, :message => "El GLN ya se encuentra asociado al prefijo"} # Una empresa no puede tener GLN repetidos
  
end
