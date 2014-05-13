class Gln < ActiveRecord::Base
  attr_accessible :calle, :cod_postal, :codigo_localizacion, :descripcion, :edificio, :fecha_asignacion, :id_gln, :id_ciudad, :id_estado, :id_estatus, :id_municipio, :id_pais, :punto_referencia, :tipo_gln, :urbanizacion
  self.table_name = "gln"
  has_one :gln_empresa, :foreign_key => "gln"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gln, :foreign_key => "tipo_gln"
  belongs_to :estado, :foreign_key => "id_estado"
  belongs_to :ciudad, :foreign_key => "id_ciudad"
  belongs_to :pais, :foreign_key => "id_pais"
  belongs_to :municipio, :foreign_key => "id_municipio"

end
