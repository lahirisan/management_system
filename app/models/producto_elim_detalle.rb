class ProductoElimDetalle < ActiveRecord::Base
  attr_accessible :fecha_eliminacion, :gtin, :id_usuario
  self.table_name = 'producto_elim_detalle'
  belongs_to :producto_eliminado, :foreign_key => "gtin"
end
