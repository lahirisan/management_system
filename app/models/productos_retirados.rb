class ProductosRetirados < ActiveRecord::Base
  attr_accessible :fecha_retiro, :gtin, :id_usuario
  belongs_to :producto, :foreign_key => "gtin"
end
