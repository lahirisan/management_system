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


 def self.eliminar(parametros)
 	
 	estatus_gln = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Eliminado', 'GLN'])
    
    for eliminar_gln in (0..parametros[:eliminar_glns].size-1)
      
      gln_seleccionado = parametros[:eliminar_productos][eliminar_producto]
      eliminar_datos = parametros[:"#{gln_seleccionado}"]
      gln_id = eliminar_datos.split('_')[0]
      gln = Gln.find(:first, :conditions => ["gln = ? ", gln_id]) 
      gln_eliminado = GlnEliminado.new;
      gln_eliminado.gln = gln.gln; 
      gln_eliminado.tipo_gln = gln.tipo_gln; 
      gln_eliminado.codigo_localizacion = gln.codigo_localizacion; 
      gln_eliminado.descripcion = gln.descripcion; 
      gln_eliminado.id_estatus = estatus_gln.id; 
      gln_eliminado.fecha_asignacion = gln.fecha_asignacion; 
      gln_eliminado.id_pais = gln.id_pais; 
      gln_eliminado.id_estado = gln.id_estado; 
      gln_eliminado.id_municipio = gln.id_municipio; 
      gln_eliminado.id_ciudad = gln.id_ciudad; 
      gln_eliminado.edificio = gln.edificio; 
      gln_eliminado.calle = gln.calle;
      gln_eliminado.urbanizacion = gln.urbanizacion;
      gln_eliminado.punto_referencia = gln.punto_referencia;
      gln_eliminado.cod_postal = gln.cod_postal;
      gln_eliminado.id_subestatus = eliminar_datos.split('_')[1]
      gln_eliminado.id_motivo_retiro = eliminar_datos.split('_')[2] 
      gln_eliminado.save
      gln.destroy

    end
 end

end
