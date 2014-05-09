class Correspondencia < ActiveRecord::Base
  attr_accessible :calle, :cargo_rep_tecnico, :cod_postal, :edificio, :id_ciudad, :id_estado, :id_municipio, :id_parroquia, :punto_referencia, :rep_tecnico, :urbanizacion, :correspondencia
   self.table_name = "empresa_correspondencia"
   belongs_to :empresa, :foreign_key => "prefijo"
end
