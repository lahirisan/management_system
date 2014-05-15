class GlnEliminado < ActiveRecord::Base
  attr_accessible :calle, :cod_postal, :codigo_localizacion, :descripcion, :edificio, :fecha_asignacion, :gln, :id_ciudad, :id_estado, :id_estatus, :id_municipio, :id_pais, :punto_referencia, :tipo_gln, :urbanizacion
  self.table_name = "gln_eliminado"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :id_motivo_retiro, :foreign_key => "id_motivo_retiro"
end
