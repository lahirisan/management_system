class Gln < ActiveRecord::Base
  attr_accessible :avenida, :prefijo,  :codigo_postal, :codigo_localizacion, :descripcion, :edificio, :fecha_asignacion, :ciudad, :estado, :id_estatus, :municipio,  :punto_referencia, :id_tipo_gln, :urbanizacion, :gln
  self.table_name = "gln"
  self.primary_key = "gln"
  
  belongs_to :empresa, :foreign_key => "prefijo"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gln, :foreign_key => "id_tipo_gln"

  #belongs_to :estado, :foreign_key => "id_estado"
  #belongs_to :ciudad, :foreign_key => "id_ciudad"
  # belongs_to :pais, :foreign_key => "id_pais"
  # belongs_to :municipio, :foreign_key => "id_municipio"

  validates :gln, :id_tipo_gln,  :descripcion,  :presence => {:message => "No puede estar en blanco"}, :on => :create
  #validates :cod_postal, format: { with: /^[1-9]\d*$/, on: :create, :message => "El Formato del Codigo Postal es incorrecto"} # Validacion al crear


 def self.eliminar(parametros)
 	
    for eliminar_gln in (0..parametros[:eliminar_glns].size-1)
      
      gln_seleccionado = parametros[:eliminar_glns][eliminar_gln]
      gln_ = Gln.find(:first, :conditions => ["gln = ? ", gln_seleccionado]) 
      Gln.eliminar_gln(gln_)
    end

 end


 def self.eliminar_gln(gln)

    
    gln.destroy

 end


 def self.generar_legal(prefijo_empresa)

  # OJO falta validar los casos cuando la empresa es de 9 digitos y de 6 digitos

  gln_generado = "759" + prefijo_empresa[3..6] + "90001" 

  digito_verificacion = Producto.calcular_digito_verificacion(gln_generado.to_i,"GTIN-13")
  gln = gln_generado + digito_verificacion.to_s

  gln_legal = Gln.new
  gln_legal.gln = gln
  gln_legal.id_tipo_gln = 1 # GLN LEgal segun tabla tipo_gln
  gln_legal.codigo_localizacion = "90001"
  gln_legal.descripcion = "GLN Legal"
  gln_legal.id_estatus = 9 # Estatus GLN Activo segun tabla Estatus
  gln_legal.fecha_asignacion = Time.now
  gln_legal.prefijo = prefijo_empresa
  gln_legal.save!

 end
 


 def self.generar(prefijo_empresa)

   # EL utlimo GLN asignado a la empresa ordenado por fecha descendetemente
    
    codigo_localizacion = Gln.codigo_localizacion(prefijo_empresa)
    gln_generado = "759" + prefijo_empresa[3..6] + codigo_localizacion
    digito_verificacion = Producto.calcular_digito_verificacion(gln_generado.to_i, "GTIN-13")
    gln = gln_generado + digito_verificacion.to_s
    
    return gln

 end


 def self.codigo_localizacion(prefijo_empresa)

  ultimo_gln = Gln.find(:first, :conditions => ["prefijo = ? and estatus.descripcion = ?", prefijo_empresa, 'Activo'] , :include => [:estatus], :order => "gln.codigo_localizacion desc")
  secuencia = ultimo_gln.gln[7..11]
  return Producto.completar_secuencia((secuencia.to_i + 1).to_s, "GTIN-13")
 end



 def self.retirar(prefijo)

    estatus_retirado = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", "Retirado", "GLN"])
    glns = Gln.find(:all, :conditions => ["prefijo = ?", prefijo])
    
    glns.collect{|gln|
      gln.id_estatus = estatus_retirado.id; 
      gln.save
    }
    
 end

end
