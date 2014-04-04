class Producto < ActiveRecord::Base
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca
  self.table_name = "producto"
  set_primary_key "gtin" # Se establece la clave primaria
end
