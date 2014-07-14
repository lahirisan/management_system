class Gln < ActiveRecord::Base
  attr_accessible :calle, :cod_postal, :codigo_localizacion, :descripcion, :edificio, :fecha_asignacion, :id_ciudad, :id_estado, :id_estatus, :id_municipio, :id_pais, :punto_referencia, :id_tipo_gln, :urbanizacion, :gln
  self.table_name = "gln"
  has_one :gln_empresa, :foreign_key => "id_gln"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gln, :foreign_key => "id_tipo_gln"
  belongs_to :estado, :foreign_key => "id_estado"
  belongs_to :ciudad, :foreign_key => "id_ciudad"
  belongs_to :pais, :foreign_key => "id_pais"
  belongs_to :municipio, :foreign_key => "id_municipio"

  validates :gln, :id_tipo_gln, :id_estado, :id_municipio, :id_ciudad, :descripcion,  :edificio, :calle, :urbanizacion, :punto_referencia, :cod_postal,  :presence => {:message => "No puede estar en blanco"}, :on => :create
  validates :cod_postal, format: { with: /^[1-9]\d*$/, on: :create, :message => "El Formato del Codigo Postal es incorrecto"} # Validacion al crear


 def self.eliminar(parametros)
 	
    for eliminar_gln in (0..parametros[:eliminar_glns].size-1)
      
      gln_seleccionado = parametros[:eliminar_glns][eliminar_gln]
      eliminar_datos = parametros[:"#{gln_seleccionado}"]
      gln_id = eliminar_datos.split('_')[0]
      gln_ = Gln.find(:first, :conditions => ["gln = ? ", gln_id]) 
      Gln.eliminar_gln(gln_,eliminar_datos.split('_')[1],eliminar_datos.split('_')[2])
    end

 end


 def self.eliminar_gln(gln, sub_estatus, motivo_retiro)

    estatus_gln = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Eliminado', 'GLN'])

    gln_eliminado = GlnEliminado.new
    gln_eliminado.gln = gln.gln
    gln_eliminado.id_tipo_gln = gln.id_tipo_gln
    gln_eliminado.codigo_localizacion = gln.codigo_localizacion
    gln_eliminado.descripcion = gln.descripcion
    gln_eliminado.id_estatus = estatus_gln.id
    gln_eliminado.fecha_asignacion = gln.fecha_asignacion
    gln_eliminado.id_pais = gln.id_pais
    gln_eliminado.id_estado = gln.id_estado
    gln_eliminado.id_municipio = gln.id_municipio
    gln_eliminado.id_ciudad = gln.id_ciudad
    gln_eliminado.edificio = gln.edificio
    gln_eliminado.calle = gln.calle
    gln_eliminado.urbanizacion = gln.urbanizacion
    gln_eliminado.punto_referencia = gln.punto_referencia
    gln_eliminado.cod_postal = gln.cod_postal
    gln_eliminado.id_subestatus = sub_estatus
    gln_eliminado.id_motivo_retiro = motivo_retiro 
    gln_eliminado.fecha_eliminacion = Time.now 
    gln_eliminado.save
    gln.destroy

 end


 def self.generar_legal(prefijo_empresa)

  # OJO falta validar los casos cuando la empresa es de 9 digitos y de 6 digitos
  
  empresa = Empresa.find(:first, :conditions => ["prefijo = ?", prefijo_empresa])
  gln_generado = "759" + prefijo_empresa[3..6] + "00001" 

  digito_verificacion = Producto.calcular_digito_verificacion(gln_generado.to_i,"GTIN-13")
  gln = gln_generado + digito_verificacion.to_s
  
  tipo_gln = TipoGln.find(:first, :conditions => ["nombre = ?", "Legal"])
  estatus = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?","Activo", "GLN"])
  pais = Pais.find(:first, :conditions => ["nombre = ?", "Venezuela"])
  
  gln_legal = Gln.new
  gln_legal.gln = gln
  gln_legal.id_tipo_gln = tipo_gln.id
  gln_legal.codigo_localizacion = "00001"
  gln_legal.descripcion = "GLN Legal"
  gln_legal.id_estatus = estatus.id
  gln_legal.fecha_asignacion = Time.now
  gln_legal.id_pais = pais.id
  gln_legal.id_estado = empresa.id_estado
  gln_legal.id_municipio = empresa.correspondencia.id_municipio # Al Legal se le esta pasando el id_municipio
  gln_legal.id_ciudad = empresa.id_ciudad
  gln_legal.edificio = "-"
  gln_legal.calle = "-"
  gln_legal.urbanizacion = "-"
  gln_legal.punto_referencia = "-"
  gln_legal.cod_postal = empresa.correspondencia.cod_postal
  gln_legal.save


  Gln.asociar_gln_empresa(gln, prefijo_empresa)

 end
 


 def self.generar(prefijo_empresa)

   # EL utlimo GLN asignado a la empresa ordenado por fecha descendetemente
    
    codigo_localizacion = Gln.codigo_localizacion(prefijo_empresa)
    gln_generado = "759" + prefijo_empresa[3..6] + codigo_localizacion
    digito_verificacion = Producto.calcular_digito_verificacion(gln_generado.to_i, "GTIN-13")
    gln = gln_generado + digito_verificacion.to_s
    Gln.asociar_gln_empresa(gln, prefijo_empresa)
    return gln

 end


 def self.codigo_localizacion(prefijo_empresa)

  ultimo_gln = GlnEmpresa.find(:first, :conditions => ["gln_empresa.prefijo = ? and estatus.descripcion = ?", prefijo_empresa, 'Activo'] , :joins => [{:gln => :estatus}], :order => "gln.fecha_asignacion desc")
  secuencia = ultimo_gln.gln.gln[7..11]
  return Producto.completar_secuencia((secuencia.to_i + 1).to_s, "GTIN-13")
 end


 def self.asociar_gln_empresa(parametro_gln, prefijo_empresa)

  empresa_gln = GlnEmpresa.new
  empresa_gln.prefijo = prefijo_empresa
  empresa_gln.id_gln = parametro_gln
  empresa_gln.save

 end


 def self.retirar(id_gln)

    estatus_retirado = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", "Retirado", "GLN"])
    gln = Gln.find(:first, :conditions => ["gln = ?", id_gln])
    gln.id_estatus = estatus_retirado.id
    gln.save
    
 end

end
