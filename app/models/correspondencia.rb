class Correspondencia < ActiveRecord::Base
  attr_accessible :calle, :cargo_rep_tecnico, :cod_postal, :edificio, :id_ciudad, :id_estado, :id_municipio, :id_parroquia, :punto_referencia, :rep_tecnico, :urbanizacion, :nombre_parroquia, :correspondencia
   self.table_name = "empresa_correspondencia"
   belongs_to :empresa, :foreign_key => "prefijo"
   belongs_to :estado, :foreign_key => "id_estado"
   belongs_to :ciudad, :foreign_key => "id_ciudad"
   belongs_to :municipio, :foreign_key => "id_municipio"
   belongs_to :parroquia, :foreign_key => "id_parroquia"

   validates :rep_tecnico, :cargo_rep_tecnico, :edificio, :calle, :urbanizacion, :id_estado, :id_ciudad , :cod_postal, :punto_referencia, :presence => {:message => "No puede estar en blanco"}, :on => :create

   def self.modificar_etiqueta(parametros)

   	etiqueta = Correspondencia.find(:first, :conditions => ["prefijo = ?", parametros[:empresa_id]])
   	etiqueta.edificio = parametros[:edificio]
   	etiqueta.calle = parametros[:calle]
   	etiqueta.urbanizacion = parametros[:urbanizacion]
   	etiqueta.id_estado = parametros[:id_estado]
   	etiqueta.id_ciudad = parametros[:id_ciudad]
   	etiqueta.id_municipio = parametros[:id_municipio]
   	etiqueta.id_parroquia = parametros[:id_parroquia]
      etiqueta.nombre_parroquia = parametros[:nombre_parroquia]
   	etiqueta.cod_postal = parametros[:cod_postal]
   	etiqueta.punto_referencia = parametros[:punto_referencia]
   	etiqueta.save

   	DatosContacto.modificar_etiqueta(parametros)

   end
  
end
