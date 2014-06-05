class ProductoElimDetalle < ActiveRecord::Base
  attr_accessible :fecha_eliminacion, :gtin, :id_usuario, :id_motivo_retiro, :id_subestatus
  self.table_name = 'producto_elim_detalle'
  belongs_to :producto_eliminado, :foreign_key => "gtin"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
 
end
