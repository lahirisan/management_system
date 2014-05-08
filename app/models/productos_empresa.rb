class ProductosEmpresa < ActiveRecord::Base
  attr_accessible :gtin, :prefijo
  self.table_name = "productos_empresa"
  belongs_to :empresa , :foreign_key => "prefijo"
  belongs_to :empresa_eliminada , :foreign_key => "prefijo"
  belongs_to :producto, :foreign_key => "gtin"
  belongs_to :producto_eliminado, :foreign_key => "gtin"
  belongs_to :empresas_retiradas, :foreign_key => "prefijo"

end
