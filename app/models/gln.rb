class Gln < ActiveRecord::Base
  attr_accessible :calle, :cod_postal, :codigo_localizacion, :descripcion, :edificio, :fecha_asignacion, :id_gln, :id_ciudad, :id_estado, :id_estatus, :id_municipio, :id_pais, :punto_referencia, :id_tipo_gln, :urbanizacion, :gln
  self.table_name = "gln"
  has_one :gln_empresa, :foreign_key => "id_gln"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gln, :foreign_key => "id_tipo_gln"
  belongs_to :estado, :foreign_key => "id_estado"
  belongs_to :ciudad, :foreign_key => "id_ciudad"
  belongs_to :pais, :foreign_key => "id_pais"
  belongs_to :municipio, :foreign_key => "id_municipio"

  validates :gln, :id_tipo_gln, :codigo_localizacion, :descripcion,   :id_estado, :id_municipio, :id_ciudad, :edificio, :calle, :urbanizacion, :punto_referencia, :cod_postal,  :presence => {:message => "No puede estar en blanco"}, :on => :create


 def self.eliminar(parametros)
 	
 	estatus_gln = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Eliminado', 'GLN'])
    
    for eliminar_gln in (0..parametros[:eliminar_glns].size-1)
      
      gln_seleccionado = parametros[:eliminar_glns][eliminar_gln]
      eliminar_datos = parametros[:"#{gln_seleccionado}"]
      gln_id = eliminar_datos.split('_')[0]
      gln = Gln.find(:first, :conditions => ["gln = ? ", gln_id]) 
      gln_eliminado = GlnEliminado.new;
      gln_eliminado.gln = gln.gln; 
      gln_eliminado.id_tipo_gln = gln.id_tipo_gln; 
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
      gln_eliminado.fecha_eliminacion = Time.now 
      gln_eliminado.save
      gln.destroy

    end
 end


 def self.generar_gln(prefijo_empresa)

  # OJO falta validar los casos cuando la empresa es de 9 digitos y de 6 digitos
  
  empresa = Empresa.find(:first, :conditions => ["prefijo = ?", prefijo_empresa])

  # Se verifica si la empresa tiene GLN

  if empresa.gln.empty?  # La empresa no tiene GLN
    gln_generado = "759" + prefijo_empresa[3..6] + "00001" 
    digito_verificacion = Producto.calcular_digito_verificacion(gln_generado.to_i,"GTIN-13")
    gln = gln_generado + digito_verificacion.to_s

  else
    
    # EL utlimo GLN asignado a la empresa ordenado por fecha descendetemente
    ultimo_gln = GlnEmpresa.find(:first, :conditions => ["gln_empresa.prefijo = ? and estatus.descripcion = ?", prefijo_empresa, 'Activo'] , :joins => [{:gln => :estatus}], :order => "gln.fecha_asignacion desc")
    secuencia = ultimo_gln.gln.gln[7..11]
    gln_generado = "759" + prefijo_empresa[3..6] + Producto.completar_secuencia((secuencia.to_i + 1).to_s, "GTIN-13")
    digito_verificacion = Producto.calcular_digito_verificacion(gln_generado.to_i, "GTIN-13")
    gln = gln_generado + digito_verificacion.to_s
  end

  # Se asocia el GLN con la empresa

  empresa_gln = GlnEmpresa.new
  empresa_gln.prefijo = prefijo_empresa
  empresa_gln.id_gln = gln
  empresa_gln.save

  return gln

 end

end
