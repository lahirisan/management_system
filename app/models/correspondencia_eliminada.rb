class CorrespondenciaEliminada < ActiveRecord::Base
   self.table_name = "empresa_correspondencia_eliminada"
   attr_accessible :calle, :cod_postal, :edificio, :id_ciudad, :id_estado, :id_municipio, :id_parroquia, :prefijo, :punto_referencia, :rep_tecnico, :urbanizacion

   belongs_to :empresa, :foreign_key => "prefijo"
   belongs_to :estado, :foreign_key => "id_estado"
   belongs_to :ciudad, :foreign_key => "id_ciudad"

end
