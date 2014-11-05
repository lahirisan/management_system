class Empresa < ActiveRecord::Base
  self.table_name = "empresa"  # El nombre de la tabla que se esta mapeando
  set_primary_key "prefijo" # Se establece la clave primaria
  
  # La Asociacion tienen  que ir primero si se utiliza accepts_nested_attributes

  #accepts_nested_attributes_for :correspondencia, :allow_destroy => true # Maneja el modelo correspondencia en el formulario de empresa  
  #accepts_nested_attributes_for :datos_contacto, :allow_destroy => true # Maneja el modelo correspondencia en el formulario de empresa  
  
  attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_estatus, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif, :prefijo,  :numero_registro_mercantil, :tomo_registro_mercantil, :nit_registro_mercantil, :nacionalidad_responsable_legal, :domicilio_responsable_legal, :cedula_responsable_legal, :circunscripcion_judicial, :ventas_brutas_anuales, :fecha_registro_mercantil, :contacto_tlf1, :contacto_tlf2, :contacto_tlf3, :contacto_fax, :contacto_email1, :contacto_email2, :rep_ean, :rep_ean_cargo, :direccion_ean1, :direccion_ean3, :direccion_ean4, :id_estado_ean, :id_ciudad_ean, :id_municipio_ean, :parroquia_ean, :punto_ref_ean, :cod_postal_ean, :telefono1_ean, :telefono2_ean, :telefono3_ean, :fax_ean, :email1_ean, :email2_ean, :rep_edi, :rep_edi_cargo, :direccion_edi1, :direccion_edi2, :direccion_edi3, :id_estado_edi, :id_ciudad_edi, :id_municipio_edi, :parroquia_edi, :punto_ref_edi, :codigo_postal_edi, :telefono1_edi, :telefono2_edi, :telefono3_edi, :fax_edi, :email1_edi, :rep_recursos, :rep_recursos_cargo, :telefono1_recursos, :fax_recursos, :email_recursos, :rep_mercadeo, :rep_mercadeo_cargo, :telefono1_mercadeo, :fax_mercadeo, :email_mercadeo, :direccion_ean, :direccion_edi, :direccion_recursos, :direccion_mercadeo, :fecha_activacion, :id_subestatus, :administrativo
  
  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :tipo_usuario, :foreign_key => "id_tipo_usuario"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"

  
  has_many :producto, :foreign_key => "prefijo", :dependent => :destroy# Define una asociaicion 1 a N con productos_empresa
  has_many :empresa_servicio, :foreign_key => "prefijo", :dependent => :destroy
  
  # Asi es como se debe hacer con las asociaciones con tablas de por medio, para manejar correctamente los helper de los formularios
  has_many :gln, :foreign_key => "prefijo" , :dependent => :destroy# Define una asociaicion 1 a N con productos_empresa

  
  belongs_to :tipo_usuario_empresa, :foreign_key => "id_tipo_usuario"
  
  

  def self.to_csv # Se genera el CSV de Empresas

  	CSV.generate do |csv|
  		csv << ['prefijo', 'Nombre Empresa', 'Fecha Inscripcion', 'Direccion Empresa', 'Estado', 'Ciudad', 'RIF', 'Estatus', 'Nombre Comercial', 'Clasificacion', 'Categoria', 'Division', 'Grupo', 'Clase', 'Rep Legal', 'Cargo Rep Legal']
      all.each do |empresa|
        contacto =  DatosContacto.find(:first, :conditions => ["prefijo = ? and tipo = ?", empresa.prefijo, 'principal'])
        fecha_inscripcion =  empresa.fecha_inscripcion.nil? ? '' : empresa.fecha_inscripcion.strftime("%Y-%m-%d") 
        csv << [empresa.prefijo, empresa.nombre_empresa, fecha_inscripcion,  empresa.direccion_empresa, empresa.try(:estado).try(:nombre), empresa.try(:ciudad).try(:nombre), empresa.rif, empresa.estatus.descripcion, empresa.nombre_comercial, empresa.try(:clasificacion).try(:descripcion), empresa.try(:clasificacion).try(:categoria), empresa.try(:clasificacion).try(:division), empresa.try(:clasificacion).try(:grupo), empresa.try(:clasificacion).try(:clase), contacto.try(:nombre_contacto), contacto.try(:cargo_contacto)]

  		end
    end 
  end

 
  def self.cambiar_sub_estatus(parametros)
    
    parametros[:sub_estatus_empresas].collect{|empresa_seleccionada|  empresa = Empresa.find(empresa_seleccionada); empresa.id_subestatus = parametros[:"#{empresa.prefijo}"].to_i; empresa.save}

  end

  def self.retirar_empresas(parametros)
    
    #En el parametro activar empresa estan cada uno de los ID de las empresas que se van a retirar. A su vez ese es el nombre del input asociado a la empresa y tiene el valor de los campos sub-estatus y motivo-retiro
    # OJO: Esto se puede optimizar actualizando masivamente // Refrencia RailCast 198
  
      for retirar_empresas in (0..parametros[:retirar_empresas].size-1)
       
        empresa_seleccionada = parametros[:retirar_empresas][retirar_empresas]
        retirar_datos = parametros[:"#{empresa_seleccionada}"]
        
        empresa = Empresa.find(:first, :conditions => ["prefijo = ?", retirar_datos.split('_')[0]]) # La clave primaria es es prefijo
        
        # # El estatus de retirada Se cambia el estatus de la empresa
        estatus_retirada = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", 'Retirada', 'Empresa'])
        empresa.id_estatus = estatus_retirada.id
        empresa.fecha_retiro = Time.now
        empresa.id_motivo_retiro = retirar_datos.split('_')[1]
        empresa.save

        # Se registra la persona que retiro la empresa
        #Auditoria.registrar_evento(session[:usuario],"empresa", "Retirar", Time.now,  "EMPRESA RETIRADA. PREFIJO:#{empresa.prefijo}")
        
        # Se retiran todo los productos de la empresa
        Producto.retirar_productos(empresa.prefijo)

        # Retirar GLN ojo REVISAR
        Gln.retirar(empresa.prefijo)


      end
  end

  def self.eliminar_empresas(parametros)
    
    # OJO: Esto se peude optimizar actualizando masivamente // RailsCast 198
    
      for eliminar_empresas in (0..parametros[:eliminar_empresas].size-1)
        empresa_seleccionada = parametros[:eliminar_empresas][eliminar_empresas]
        
        empresa_eliminar = Empresa.find(empresa_seleccionada)
        
        empresa_eliminada = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", empresa_eliminar.prefijo])

        empresa_eliminada.destroy if empresa_eliminada
        Empresa.registrar_eliminada(empresa_eliminar)
        empresa_eliminar.destroy # Se elimina la retirada
        
      end
  end
  

  def self.reactivar_empresas_retiradas(parametros)
    
    estatus_empresa = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Activa', 'Empresa'])
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Activo', 'Producto'])
    estatus_gln = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Activo', 'GLN'])


    parametros[:reactivar_empresas].collect{|prefijo| empresa = Empresa.find(:first, :conditions => ["prefijo = ?", prefijo]);
      empresa.id_estatus = estatus_empresa.id;
      empresa.save;
      empresa.producto.collect{|objeto_producto| producto = Producto.find(:first, :conditions => ["gtin = ?", objeto_producto.gtin]);
        producto.id_estatus = estatus_producto.id;
        producto.save;
        };
      empresa.gln.collect{ |objeto_gln| gln = Gln.find(:first, :conditions => ["gln = ?", objeto_gln.gln]);
        gln.id_estatus = estatus_gln.id;
        gln.save
      };

    } 

     
  end


  

  def self.generar_prefijo_valido

    # Falta validar el caso en que no hay PREFIJOS disponibles 759XXXX
    
    empresa = Empresa.find(:first, :conditions => ["prefijo >= 7590000 and prefijo <= 7599999 and prefijo != 7599000 "], :order => "prefijo DESC")
    prefijo = empresa.prefijo + 1
    prefijo = prefijo + 1 if prefijo == 7599000 # PREFIJO de GS1
    prefijo = busqueda_exhaustiva_prefijo if (prefijo > 7599999) ## Probar en su momento

    return prefijo

  end
  
  def self.busqueda_exhaustiva_prefijo

    prefijos_asignados = Empresa.find(:all, :conditions => ["prefijo >= 7590000 and prefijo <= 75999999"])
    prefijos_disponible = Empresa.find(:first, :conditions => ["prefijo >= ? and prefijo <= ? and prefijo not in (?)", 7599000, 7599999, prefijos_asignados.collect{|empresa| empresa.prefijo}], :order => "empresa.prefijo asc")

    return (prefijos_disponible.prefijo)

  end

 

  def self.registrar_historico_eliminada(eliminada)

    

        historico_eliminada = HistoricoEliminada.new
       historico_eliminada.prefijo = eliminada.prefijo
       historico_eliminada.nombre_empresa = eliminada.nombre_empresa
       historico_eliminada.rif = eliminada.rif
       historico_eliminada.rep_legal = eliminada.rep_legal
       historico_eliminada.contacto_tlf1 = eliminada.contacto_tlf1
       historico_eliminada.contacto_email1 = eliminada.contacto_email1
       historico_eliminada.fecha_liberacion_prefijo = Time.now
       historico_eliminada.save
       eliminada.destroy

  end


  def self.registrar_eliminada(empresa)


     estatus_empresa = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ? ", "Eliminada", 'Empresa'])
        

    empresa_eliminada =  EmpresaEliminada.new  # Se crear el registro de la empresa_eliminada
    empresa_eliminada.prefijo = empresa.prefijo
    empresa_eliminada.nombre_empresa = empresa.nombre_empresa

    empresa_eliminada.rif = empresa.rif.strip

    empresa_eliminada.categoria = empresa.try(:categoria)
    empresa_eliminada.division = empresa.try(:division)
    empresa_eliminada.grupo = empresa.try(:grupo)
    empresa_eliminada.clase = empresa.try(:clase)
    empresa_eliminada.rep_legal = empresa.try(:rep_legal)
    empresa_eliminada.contacto_tlf1 = empresa.try(:contacto_tlf1)
    empresa_eliminada.contacto_email1 = empresa.try(:contacto_email1)
    empresa_eliminada.id_motivo_retiro = empresa.try(:id_motivo_retiro)
    empresa_eliminada.id_tipo_usuario_empresa = empresa.try(:id_tipo_usuario)
    empresa_eliminada.fecha_retiro = empresa.try(:fecha_retiro)
    empresa_eliminada.fecha_eliminacion = Time.now
    empresa_eliminada.id_estatus = estatus_empresa.id
    empresa_eliminada.save


 end


 def self.sincronizar_solventes_desde_excel ## Procedimiento para sincronizar el estatus de las empresas  SOLVENTES

  spreadsheet = Roo::Excelx.new("#{Rails.root}/doc/SOLVENTES.xlsx", nil, :ignore)

    (2..spreadsheet.last_row).each do |fila|

       empresa_solvente = Empresa.find(spreadsheet.cell(fila,1))
     
         raise "No se encontro el prefijo #{spreadsheet.cell(fila,1)}".to_yaml if empresa_solvente.nil?
         empresa_solvente.id_subestatus = 1
         empresa_solvente.save
     

    end


 end


 def self.sincronizar_aporte_mantenimiento ## Procedimiento para sincronizar el estatus de las empresas  SOLVENTES

  spreadsheet = Roo::Excelx.new("#{Rails.root}/doc/aporte_mantenimiento.xlsx", nil, :ignore)

    (1..spreadsheet.last_row).each do |fila|

       empresa = Empresa.find(spreadsheet.cell(fila,1))
     
        if empresa
          empresa.aporte_mantenimiento = (spreadsheet.cell(fila,2))
          empresa.save
        end
     

    end


 end


 def self.activar(empresa_registrada)


  estatus = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", "Activa", "Empresa"])

  empresa = Empresa.new
  empresa.prefijo = empresa_registrada.prefijo
  empresa.nombre_empresa = empresa_registrada.nombre_empresa
  empresa.fecha_inscripcion = empresa_registrada.fecha_inscripcion
  empresa.direccion_empresa = empresa_registrada.direccion_empresa
  empresa.id_estado = empresa_registrada.id_estado
  empresa.id_ciudad = empresa_registrada.id_ciudad
  empresa.rif = empresa_registrada.rif
  empresa.id_estatus = estatus.id
  empresa.id_tipo_usuario = empresa_registrada.id_tipo_usuario
  empresa.nombre_comercial = empresa_registrada.nombre_comercial
  empresa.id_clasificacion = empresa_registrada.id_clasificacion
  empresa.categoria = empresa_registrada.categoria
  empresa.division = empresa_registrada.division
  empresa.grupo = empresa_registrada.grupo
  empresa.clase = empresa_registrada.clase
  empresa.rep_legal = empresa_registrada.rep_legal
  empresa.cargo_rep_legal = empresa_registrada.cargo_rep_legal
  empresa.circunscripcion_judicial = empresa_registrada.circunscripcion_judicial
  empresa.numero_registro_mercantil = empresa_registrada.numero_registro_mercantil
  empresa.tomo_registro_mercantil = empresa_registrada.tomo_registro_mercantil
  empresa.nacionalidad_responsable_legal = empresa_registrada.nacionalidad_responsable_legal
  empresa.domicilio_responsable_legal = empresa_registrada.domicilio_responsable_legal
  empresa.cedula_responsable_legal = empresa_registrada.cedula_responsable_legal
  empresa.ventas_brutas_anuales = empresa_registrada.ventas_brutas_anuales
  empresa.aporte_mantenimiento_bs = empresa_registrada.aporte_mantenimiento_bs
  empresa.fecha_registro_mercantil = empresa_registrada.fecha_registro_mercantil
  empresa.id_parroquia_empresa = empresa_registrada.id_parroquia_empresa
  empresa.parroquia_empresa = empresa_registrada.parroquia_empresa
  empresa.contacto_tlf2 = empresa_registrada.contacto_tlf2
  empresa.contacto_tlf3 = empresa_registrada.contacto_tlf3
  empresa.contacto_fax = empresa_registrada.contacto_fax
  empresa.contacto_email1 = empresa_registrada.contacto_email1
  empresa.contacto_email2 = empresa_registrada.contacto_email2
  empresa.fecha_ultima_modificacion = empresa_registrada.fecha_ultima_modificacion
  empresa.rep_ean_cargo = empresa_registrada.rep_ean_cargo
  empresa.punto_ref_ean = empresa_registrada.punto_ref_ean
  empresa.id_estado_ean = empresa_registrada.id_estado_ean
  empresa.id_ciudad_ean = empresa_registrada.id_ciudad_ean
  empresa.id_parroquia_ean = empresa_registrada.id_parroquia_ean
  empresa.parroquia_ean = empresa_registrada.parroquia_ean
  empresa.cod_postal_ean = empresa_registrada.cod_postal_ean
  empresa.telefono1_ean = empresa_registrada.telefono1_ean
  empresa.telefono2_ean = empresa_registrada.telefono2_ean
  empresa.telefono3_ean = empresa_registrada.telefono3_ean
  empresa.fax_ean = empresa_registrada.fax_ean
  empresa.email1_ean = empresa_registrada.email1_ean
  empresa.email2_ean = empresa_registrada.email2_ean
  empresa.rep_edi = empresa_registrada.rep_edi
  empresa.rep_edi_cargo = empresa_registrada.rep_edi_cargo
  empresa.id_ciudad_edi = empresa_registrada.id_ciudad_edi
  empresa.punto_ref_edi = empresa_registrada.punto_ref_edi
  empresa.codigo_postal_edi = empresa_registrada.codigo_postal_edi
  empresa.telefono1_edi = empresa_registrada.telefono1_edi
  empresa.telefono2_edi = empresa_registrada.telefono2_edi
  empresa.telefono3_edi = empresa_registrada.telefono3_edi
  empresa.fax_edi = empresa_registrada.fax_edi
  empresa.email1_edi = empresa_registrada.email1_edi
  empresa.id_municipio_ean = empresa_registrada.id_municipio_ean
  empresa.id_municipio_edi = empresa_registrada.id_municipio_edi
  empresa.id_parroquia_edi = empresa_registrada.id_parroquia_edi
  empresa.rep_mercadeo = empresa_registrada.rep_mercadeo
  empresa.rep_mercadeo_cargo = empresa_registrada.rep_mercadeo_cargo
  empresa.telefono1_mercadeo = empresa_registrada.telefono1_mercadeo
  empresa.fax_mercadeo = empresa_registrada.fax_mercadeo
  empresa.email_mercadeo = empresa_registrada.fax_mercadeo
  empresa.email_mercadeo = empresa_registrada.email_mercadeo
  empresa.rep_recursos = empresa_registrada.rep_recursos
  empresa.rep_recursos_cargo = empresa_registrada.rep_recursos_cargo
  empresa.telefono1_recursos = empresa_registrada.telefono1_recursos
  empresa.fax_recursos = empresa_registrada.fax_recursos
  empresa.email_recursos = empresa_registrada.email_recursos
  empresa.contacto_tlf1 = empresa_registrada.contacto_tlf1
  empresa.rep_ean = empresa_registrada.rep_ean
  empresa.parroquia_edi = empresa_registrada.parroquia_edi
  empresa.id_estado_edi = empresa_registrada.id_estado_edi
  empresa.direccion_ean = empresa_registrada.direccion_ean
  empresa.direccion_edi = empresa_registrada.direccion_edi
  empresa.id_subestatus = empresa_registrada.id_subestatus
  empresa.fecha_activacion = Time.now
  empresa.save
 
  empresa_registrada.destroy


  
  eliminada = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", empresa.prefijo])
  Empresa.registrar_historico_eliminada(eliminada) if eliminada # Se esta utilizando un prefijo de empresa eliminada
  Gln.generar_legal(empresa.prefijo.to_s) 

 end



end
