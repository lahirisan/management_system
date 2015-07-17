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



def self.csv_auditoria_service_retail_gln
    
    CSV.generate(:col_sep => ";") do |csv|
        
        Gln.joins(:empresa).select("empresa.nombre_empresa, gln.descripcion, gln.gln as gln_").where("(empresa.nombre_empresa = 'FARMATODO, C.A.' and gln.id_tipo_gln = 2) or (empresa.nombre_empresa = 'SUPERMERCADOS UNICASA, C.A.' and gln.id_tipo_gln = 2) or (empresa.nombre_empresa = 'EXCELSIOR GAMA SUPERMERCADOS, C.A.' and gln.id_tipo_gln = 2) or (empresa.nombre_empresa = 'CENTRAL MADEIRENSE C.A.' and gln.id_tipo_gln = 2) or (empresa.nombre_empresa like '%AUTOMERCADOS PLAZA%' and gln.id_tipo_gln = 2)").find_each do |empresa_gln|
          
          csv << [empresa_gln.nombre_empresa, empresa_gln.descripcion, empresa_gln.gln_, "414"+ empresa_gln.gln_ ]

        end
    end

end



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


 def self.importar_gln ## Procedimiento para importar GLN

  spreadsheet = Roo::Excel.new("#{Rails.root}/doc/importar_gln.xls", nil, :ignore)
    
    prefijo =  spreadsheet.sheet('GLN').cell(1,1).to_i  # El prefijo al cual se asignará los GLN
    
    (3..spreadsheet.last_row).each do |fila|

       gln = spreadsheet.sheet('GLN').cell(fila,1).to_s
       tipo_gln = spreadsheet.sheet('GLN').cell(fila,2).to_s
       tipo_gln = (tipo_gln == 'Operativo') ? '3' : '2'
       codigo_localizacion = spreadsheet.sheet('GLN').cell(fila,3).to_s
       descripcion = spreadsheet.sheet('GLN').cell(fila,4).to_s
       estado = spreadsheet.sheet('GLN').cell(fila,5).to_s
       municipio = spreadsheet.sheet('GLN').cell(fila,6).to_s
       ciudad = spreadsheet.sheet('GLN').cell(fila,7).to_s
       edificio = spreadsheet.sheet('GLN').cell(fila,8).to_s
       avenida = spreadsheet.sheet('GLN').cell(fila,9).to_s
       urbanizacion = spreadsheet.sheet('GLN').cell(fila,10).to_s
       punto_referencia = spreadsheet.sheet('GLN').cell(fila,11).to_s
       codigo_postal = spreadsheet.sheet('GLN').cell(fila,12).to_s

       nuevo_gln = Gln.new
       nuevo_gln.gln = gln
       nuevo_gln.prefijo = prefijo
       nuevo_gln.id_tipo_gln = tipo_gln
       nuevo_gln.codigo_localizacion = codigo_localizacion
       nuevo_gln.descripcion = descripcion
       nuevo_gln.estado = estado
       nuevo_gln.municipio = municipio
       nuevo_gln.ciudad = ciudad
       nuevo_gln.edificio = edificio
       nuevo_gln.avenida = avenida
       nuevo_gln.urbanizacion = urbanizacion
       nuevo_gln.punto_referencia = punto_referencia
       nuevo_gln.codigo_postal = codigo_postal
       nuevo_gln.fecha_asignacion = Time.now
       nuevo_gln.id_estatus = 9
       nuevo_gln.save
       


    end


 end


end
