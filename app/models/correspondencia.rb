class Correspondencia < ActiveRecord::Base
  attr_accessible :calle, :cargo_rep_tecnico, :cod_postal, :edificio, :id_ciudad, :id_estado, :id_municipio, :id_parroquia, :punto_referencia, :rep_tecnico, :urbanizacion, :correspondencia
   self.table_name = "empresa_correspondencia"
   belongs_to :empresa, :foreign_key => "prefijo"
   belongs_to :estado, :foreign_key => "id_estado"
   belongs_to :ciudad, :foreign_key => "id_ciudad"
   #belongs_to :municipio, :foreign_key => "id_municipio"
   #belongs_to :parroquia, :foreign_key => "id_parroquia"
end
