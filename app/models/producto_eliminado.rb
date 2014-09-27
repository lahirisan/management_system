class ProductoEliminado < ActiveRecord::Base
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca
  self.table_name = "producto_eliminado"
  belongs_to :productos_empresa, :primary_key => "gtin",  :foreign_key => "gtin" # busca los productos en productos_empresa a traves de gtin no del campo  id
  has_one :producto_elim_detalle, :foreign_key => "gtin", :dependent => :destroy # eliminacion en cascada
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gtin, :foreign_key => "id_tipo_gtin"
end
