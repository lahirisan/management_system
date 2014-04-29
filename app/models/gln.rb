class Gln < ActiveRecord::Base
  attr_accessible :calle, :cod_postal, :codigo_localizacion, :descripcion, :edificio, :fecha_asignacion, :gln, :id_ciudad, :id_estado, :id_estatus, :id_municipio, :id_pais, :punto_referencia, :tipo_gln, :urbanizacion
  self.table_name = "gln"
  belongs_to :gln_empresa, :foreign_key => "gln"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gln, :foreign_key => "tipo_gln"
  belongs_to :estado, :foreign_key => "id_estado"
  belongs_to :ciudad, :foreign_key => "id_ciudad"

end
