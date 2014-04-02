class ProductoEliminado < ActiveRecord::Base
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca
  self.table_name = "producto_eliminado"
  has_one :producto_elim_detalle, :foreign_key => "gtin", :dependent => :destroy # eliminacion en cascada
end
