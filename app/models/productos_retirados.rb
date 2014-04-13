class ProductosRetirados < ActiveRecord::Base
  attr_accessible :fecha_retiro, :gtin, :id_usuario, :id_motivo_retiro, :id_subestatus
  belongs_to :producto, :foreign_key => "gtin"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"

end
