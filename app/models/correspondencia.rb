class Correspondencia < ActiveRecord::Base
  attr_accessible :calle, :cargo_rep_tecnico, :cod_postal, :edificio, :id_ciudad, :id_estado, :id_municipio, :id_parroquia, :punto_referencia, :rep_tecnico, :urbanizacion, :correspondencia
   self.table_name = "empresa_correspondencia"
   belongs_to :empresa, :foreign_key => "prefijo"
   belongs_to :estado, :foreign_key => "id_estado"
   belongs_to :ciudad, :foreign_key => "id_ciudad"

   validates :rep_tecnico, :cargo_rep_tecnico, :edificio, :calle, :urbanizacion, :id_estado, :id_ciudad , :cod_postal, :punto_referencia, :presence => {:message => "No puede estar en blanco"}, :on => :create
  
end
