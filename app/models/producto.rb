class Producto < ActiveRecord::Base
  self.table_name = "producto"  # El nombre de la tabla que se esta mapeando
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca
  belongs_to :productos_empresa, :primary_key => "gtin",  :foreign_key => "gtin" # busca los productos en productos_empresa a traves de gtin no del campo  id
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gtin, :foreign_key => "id_tipo_gtin" 
end
