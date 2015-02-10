class GlnEliminado < ActiveRecord::Base
  attr_accessible :calle, :cod_postal, :codigo_localizacion, :descripcion, :edificio, :fecha_asignacion, :gln, :id_ciudad, :id_estado, :id_estatus, :id_municipio, :id_pais, :punto_referencia, :id_tipo_gln, :urbanizacion, :id_motivo_retiro, :id_subestatus, :fecha_eliminacion
  self.table_name = "gln_eliminado"
  has_one :gln_empresa, :foreign_key => "id_gln"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"
  belongs_to :tipo_gln, :foreign_key => "id_tipo_gln"
  belongs_to :ciudad, :foreign_key => "id_ciudad"
  belongs_to :pais, :foreign_key => "id_pais"
  belongs_to :municipio, :foreign_key => "id_municipio"
  belongs_to :estado, :foreign_key => "id_estado"

end
