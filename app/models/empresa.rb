class Empresa < ActiveRecord::Base
  self.table_name = "empresa"  # El nombre de la tabla que se esta mapeando
  set_primary_key "prefijo" # Se establece la clave primaria
  
  # La Asociacion tienen  que ir primero si se utiliza accepts_nested_attributes

  #has_many :correspondencia, :foreign_key => "prefijo", :dependent => :destroy # elimina en cascada
  #has_many :datos_contacto, :foreign_key => "prefijo", :dependent => :destroy # elimina en cascada las correspondencia de la empresa si se elimina la empresa de manera de evitar data inconsistente

  #accepts_nested_attributes_for :correspondencia, :allow_destroy => true # Maneja el modelo correspondencia en el formulario de empresa  
  #accepts_nested_attributes_for :datos_contacto, :allow_destroy => true # Maneja el modelo correspondencia en el formulario de empresa  
  attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_estatus, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif, :prefijo,  :numero_registro_mercantil, :tomo_registro_mercantil, :nit_registro_mercantil, :nacionalidad_responsable_legal, :domicilio_responsable_legal, :cedula_responsable_legal, :circunscripcion_judicial, :ventas_brutas_anuales, :fecha_registro_mercantil, :contacto_tlf1, :contacto_tlf2, :contacto_tlf3, :contacto_fax, :contacto_email1, :contacto_email2, :rep_ean, :rep_ean_cargo, :direccion_ean1, :direccion_ean3, :direccion_ean4, :id_estado_ean, :id_ciudad_ean, :id_municipio_ean, :parroquia_ean, :punto_ref_ean, :cod_postal_ean, :telefono1_ean, :telefono2_ean, :telefono3_ean, :fax_ean, :email1_ean, :email2_ean, :rep_edi, :rep_edi_cargo, :direccion_edi1, :direccion_edi2, :direccion_edi3, :id_estado_edi, :id_ciudad_edi, :id_municipio_edi, :parroquia_edi, :punto_ref_edi, :codigo_postal_edi, :telefono1_edi, :telefono2_edi, :telefono3_edi, :fax_edi, :email1_edi, :rep_recursos, :rep_recursos_cargo, :telefono1_recursos, :fax_recursos, :email_recursos, :rep_mercadeo, :rep_mercadeo_cargo, :telefono1_mercadeo, :fax_mercadeo, :email_mercadeo, :direccion_ean, :direccion_edi, :direccion_recursos, :direccion_mercadeo, :fecha_activacion, :id_subestatus
  
  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :tipo_usuario, :foreign_key => "id_tipo_usuario"
  has_one  :empresas_retiradas,  :foreign_key => "prefijo" , :dependent => :destroy   # Define una asociacion 1 a 1 con empresas_retiradas, eliminacion en cascada
  #has_many :productos_empresa, :foreign_key => "prefijo" # Define una asociaicion 1 a N con productos_empresa
  has_many :producto, :foreign_key => "prefijo", :dependent => :destroy# Define una asociaicion 1 a N con productos_empresa
  has_many :empresa_servicio, :foreign_key => "prefijo", :dependent => :destroy
  
  # Asi es como se debe hacer con las asociaciones con tablas de por medio, para manejar correctamente los helper de los formularios
  has_many :gln, :foreign_key => "prefijo"

  
  belongs_to :tipo_usuario_empresa, :foreign_key => "id_tipo_usuario"
  
  validates :id_tipo_usuario, :nombre_empresa, :fecha_inscripcion,  :id_estado, :id_ciudad, :direccion_empresa, :contacto_tlf1, :contacto_email1,  :rif, :prefijo,  :rep_legal, :cargo_rep_legal,  :presence => {:message => "No puede estar en blanco"}, :on => :create
  #validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{5,8})-([0-9]{1})$/, on: :create, :message => "El Formato del RIF es invalido"} # Validacion al crear
  validates :rif, :uniqueness => {:message => "La aplicacion detecto que el RIF que esta ingresando ya esta registrado. Por favor verifique."}, :on => :create

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

  def self.validar_empresas(empresas) # Procedimiento para validar Empresas
    @estatus_activa = Estatus.find(:first, :conditions => ["descripcion like ?", "Activa"]) # Se busca el ID de Estatus Activa
    @empresas = Empresa.find(:all, :conditions => ["prefijo in (?)", empresas.collect{|prefijo| prefijo}])
    subestatus = SubEstatus.find(:first, :conditions => ["descripcion = ?", "SOLVENTE"]) # La empresa esta solvente
    @empresas.collect{|empresa_seleccionada| empresa = Empresa.find(empresa_seleccionada.prefijo); empresa.id_estatus = @estatus_activa.id; empresa.id_subestatus = subestatus.id; empresa.fecha_activacion = Time.now; empresa.save}

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
        retirar_datos.split('_')[0] # retirar_datos.split('_')[0] Prefijo de la empresa retirar_datos.split('_')[1] id sub_estatus retirar_datos.split('_')[2] id motivo_retiro
        empresa_retirar =  EmpresasRetiradas.new 
        empresa_retirar.prefijo = retirar_datos.split('_')[0]
        fecha_retiro = Time.now
        empresa_retirar.fecha_retiro = fecha_retiro
        empresa_retirar.id_motivo_retiro = retirar_datos.split('_')[1]
        empresa_retirar.save
        
        empresa = Empresa.find(:first, :conditions => ["prefijo = ?", retirar_datos.split('_')[0]]) # La clave primaria es es prefijo
        
        # # El estatus de retirada Se cambia el estatus de la empresa
        estatus_retirada = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", 'Retirada', 'Empresa'])
        empresa.id_estatus = estatus_retirada.id
        empresa.save

        # Se retiran todo los productos de la empresa
        Producto.retirar_productos_empresa(empresa.prefijo, retirar_datos.split('_')[2], retirar_datos.split('_')[1])

        # Retirar GLN ojo REVISAR
        empresa.gln_empresa.collect{| gln_empresa | Gln.retirar(gln_empresa.id_gln) }
    

      end
  end

  def self.eliminar_empresas(parametros)
    
    #En el parametro activar empresa estan cada uno de los ID de las empresas que se van a retirar. A su vez ese es el nombre del input asociado a la empresa y tiene el valor de los campos sub-estatus y motivo-retiro
    # OJO: Esto se peude optimizar actualizando masivamente // RailsCast 198
      

      for eliminar_empresas in (0..parametros[:eliminar_empresas].size-1)
        empresa_seleccionada = parametros[:eliminar_empresas][eliminar_empresas]
        
        #eliminar_datos = parametros[:"#{empresa_seleccionada}"]
        #eliminar_datos.split('_')[0] # eliminar_datos.split('_')[0] Prefijo de la empresa eliminar_datos.split('_')[1] id sub_estatus eliminar_datos.split('_')[2] id motivo_retiro
        
        # Se busca la empresa para obtener todos sus datos
        empresa_eliminar = Empresa.find(empresa_seleccionada)
        estatus_empresa = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ? ", "Eliminada", 'Empresa'])
        
        empresa_eliminada =  EmpresaEliminada.new  # Se crear el registro de la empresa_eliminada
        empresa_eliminada.prefijo = empresa_eliminar.prefijo
        empresa_eliminada.nombre_empresa = empresa_eliminar.nombre_empresa
        empresa_eliminada.fecha_inscripcion = empresa_eliminar.fecha_inscripcion
        empresa_eliminada.direccion_empresa = empresa_eliminar.direccion_empresa
        empresa_eliminada.id_estado = empresa_eliminar.id_estado 
        empresa_eliminada.id_ciudad = empresa_eliminar.id_ciudad
        empresa_eliminada.rif = empresa_eliminar.rif.strip
        empresa_eliminada.id_estatus = estatus_empresa.id  
        empresa_eliminada.id_tipo_usuario = empresa_eliminar.id_tipo_usuario
        empresa_eliminada.nombre_comercial = empresa_eliminar.try(:nombre_comercial)
        empresa_eliminada.id_clasificacion = empresa_eliminar.try(:id_clasificacion)
        empresa_eliminada.categoria = empresa_eliminar.try(:categoria)
        empresa_eliminada.division = empresa_eliminar.try(:division)
        empresa_eliminada.grupo = empresa_eliminar.try(:grupo)
        empresa_eliminada.clase = empresa_eliminar.try(:clase)
        empresa_eliminada.rep_legal = empresa_eliminar.try(:rep_legal)
        empresa_eliminada.cargo_rep_legal = empresa_eliminar.try(:cargo_rep_legal)
        #empresa_eliminada.id_motivo_retiro = eliminar_datos.split('_')[2]
        #empresa_eliminada.id_subestatus = eliminar_datos.split('_')[1]
        empresa_eliminada.save

        # OJO Pendiente la correspondencia de la eliminada

        #crear_correspondencia_eliminada(empresa_eliminar) if (empresa_eliminar.correspondencia) # Correspondencia

        empresa_eliminada_detalle = EmpresaElimDetalle.new
        empresa_eliminada_detalle.prefijo = empresa_eliminada.prefijo
        empresa_eliminada_detalle.fecha_eliminacion = Time.now
        empresa_eliminada_detalle.id = empresa_eliminada.prefijo
        empresa_eliminada_detalle.save
        
        estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Eliminado', 'Producto'])
        
        #Los productos se agrega a productos eliminados

          empresa_eliminar.productos_empresa.collect{|producto_empresa|
          producto_eliminado = ProductoEliminado.new; 
          producto_eliminado.gtin = producto_empresa.try(:producto).try(:gtin); 
          producto_eliminado.descripcion = producto_empresa.try(:producto).try(:descripcion); 
          producto_eliminado.marca = producto_empresa.try(:producto).try(:marca); 
          producto_eliminado.gpc = producto_empresa.try(:producto).try(:gpc); 
          producto_eliminado.id_estatus = estatus_producto.id; 
          producto_eliminado.codigo_prod = producto_empresa.try(:producto).try(:codigo_prod); 
          producto_eliminado.fecha_creacion = Time.now; 
          producto_eliminado.id_tipo_gtin = producto_empresa.try(:producto).try(:id_tipo_gtin); 
          producto_eliminado.save; producto_elim_detalle = ProductoElimDetalle.new; 
          producto_elim_detalle.gtin = producto_empresa.try(:producto).try(:gtin); 
          producto_elim_detalle.fecha_eliminacion = Time.now;
         # producto_elim_detalle.id_motivo_retiro =  eliminar_datos.split('_')[2];
         # producto_elim_detalle.id_subestatus =  eliminar_datos.split('_')[1];

          producto_elim_detalle.save}

        # Se elimina los productos de la empresa
        empresa_eliminar.productos_empresa.collect{|productos_empresa| producto = Producto.find(:first, :conditions => ["gtin like ?", productos_empresa.gtin]); producto.destroy}

        # Se elimina los servicios de la empresa
        empresa_eliminar.empresa_servicio.collect{|servicio| EmpresaServicio.servicio_eliminado(servicio,1,1)}

        # Se elimina el GLN
        empresa_eliminar.gln_empresa.collect{|gln_empresa| Gln.eliminar_gln(gln_empresa.gln,1,1)}

        # OJO Antesd de hacer esto se debe guardar las corespondencicias

        correspondencias = Correspondencia.find(:all, :conditions => ["prefijo = ?", empresa_eliminar.prefijo])
        correspondencias.collect{|correspondencia| correspondencia.destroy}
        

        empresa_eliminar.destroy
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


  def self.crear_correspondencia_eliminada(empresa)
      
      correspondencia_eliminada = CorrespondenciaEliminada.new;
      correspondencia_eliminada.prefijo = empresa.correspondencia.prefijo;
      correspondencia_eliminada.rep_tecnico = empresa.correspondencia.rep_tecnico;
      correspondencia_eliminada.cargo_rep_tecnico = empresa.correspondencia.cargo_rep_tecnico;
      correspondencia_eliminada.edificio = empresa.correspondencia.edificio;
      correspondencia_eliminada.calle = empresa.correspondencia.calle;
      correspondencia_eliminada.urbanizacion = empresa.correspondencia.urbanizacion;
      correspondencia_eliminada.cargo_rep_tecnico = empresa.correspondencia.cargo_rep_tecnico;
      correspondencia_eliminada.id_estado = empresa.correspondencia.id_estado;
      correspondencia_eliminada.id_municipio = empresa.correspondencia.id_municipio;
      correspondencia_eliminada.cod_postal = empresa.correspondencia.cod_postal;
      correspondencia_eliminada.punto_referencia = empresa.correspondencia.punto_referencia;
      correspondencia_eliminada.id_parroquia= empresa.correspondencia.id_parroquia;
      correspondencia_eliminada.save;

      # Se elimina la correspondencia
      correspondencia = Correspondencia.find(:first, :conditions => ["prefijo = ?", empresa.correspondencia.prefijo])
      correspondencia.destroy

  end


  def self.crear_datos_contacto_eliminada(empresa)

    empresa.datos_contacto.collect{|contacto|

      contacto_eliminado = EmpresaContactoEliminada.new;
      contacto_eliminado.prefijo = contacto.prefijo;
      contacto_eliminado.contacto = contacto.contacto;
      contacto_eliminado.prefijo = contacto.prefijo;
      contacto_eliminado.tipo = contacto.tipo;
      contacto_eliminado.nombre_contacto = contacto.nombre_contacto;
      contacto_eliminado.cargo_contacto = contacto.cargo_contacto;
      contacto_eliminado.save;
      contacto.destroy;
    }

  end


  def self.crear_datos_contacto(contactos_eliminado)

    contactos_eliminado.collect{|contacto| 
      nuevo_contacto = DatosContacto.new;
      nuevo_contacto.prefijo = contacto.prefijo;
      nuevo_contacto.contacto = contacto.contacto;
      nuevo_contacto.tipo = contacto.tipo;
      nuevo_contacto.nombre_contacto = contacto.nombre_contacto ? contacto.nombre_contacto : "No tiene";
      nuevo_contacto.cargo_contacto = contacto.cargo_contacto ? contacto.cargo_contacto : "No tiene";
      nuevo_contacto.save;
      contacto.destroy;
    }

  end

  def self.crear_correspondencia(correspondencia_eliminada)

    correspondencia = Correspondencia.new
    correspondencia.prefijo = correspondencia_eliminada.prefijo
    correspondencia.rep_tecnico = (correspondencia_eliminada.rep_tecnico) ? correspondencia_eliminada.rep_tecnico : "No Tiene"
    correspondencia.cargo_rep_tecnico = (correspondencia_eliminada.cargo_rep_tecnico) ? correspondencia_eliminada.cargo_rep_tecnico : "No Tiene"
    correspondencia.edificio = (correspondencia_eliminada.edificio) ? correspondencia_eliminada.edificio : "No Tiene"
    correspondencia.urbanizacion = (correspondencia_eliminada.urbanizacion) ? correspondencia_eliminada.urbanizacion : "No Tiene"
    correspondencia.calle = (correspondencia_eliminada.calle) ? correspondencia_eliminada.calle : "No Tiene"
    correspondencia.id_estado = (correspondencia_eliminada.id_estado) ? correspondencia_eliminada.id_estado : 99
    correspondencia.id_ciudad = (correspondencia_eliminada.id_ciudad) ? correspondencia_eliminada.id_ciudad : 999
    correspondencia.cod_postal = (correspondencia_eliminada.cod_postal) ? correspondencia_eliminada.cod_postal : "No Tiene"
    correspondencia.punto_referencia = (correspondencia_eliminada.punto_referencia) ? correspondencia_eliminada.punto_referencia : "No Tiene"
    correspondencia.save
    correspondencia_eliminada.destroy

  end

  def self.crear_producto(productos_empresa)

    estatus = Estatus.find(:first, :conditions => ['descripcion like ? and alcance = ?', 'Activo', 'Producto'])

    productos_empresa.collect{|producto_empresa|
      producto_eliminado = ProductoEliminado.find(:first, :conditions => ["gtin like ?", producto_empresa.gtin])
      producto = Producto.new;
      producto.gtin = producto_eliminado.gtin;
      producto.descripcion = producto_eliminado.descripcion ? producto_eliminado.descripcion : "No tiene";
      producto.marca = producto_eliminado.marca ? producto_eliminado.marca : "No tiene";;
      producto.gpc = producto_eliminado.gpc ? producto_eliminado.gpc : "No tiene";;
      producto.id_estatus = estatus.id;
      producto.codigo_prod = producto_eliminado.codigo_prod ? producto_eliminado.codigo_prod : "No tiene";
      producto.fecha_creacion = producto_eliminado.fecha_creacion ? producto_eliminado.fecha_creacion : Time.now;
      producto.id_tipo_gtin = producto_eliminado.id_tipo_gtin;
      producto.save;
      producto_eliminado.destroy;

    }

  end

  def self.generar_prefijo_valido


    # Falta validar el caso en que no hay PREFIJOS disponibles 759XXXX

    
    empresa = Empresa.find(:first, :conditions => ["prefijo >= 7590000 and prefijo <= 7599999"], :order => "prefijo DESC")
    prefijo = empresa.prefijo + 1
    # Cuando la asignacion de prefijo Sea mayor a 7599999 Se hace procedera hacer una busqueda exhautiva de prefijos
    # Disponibles desde 7590000 hasta 7599999
    prefijo = busqueda_exhaustiva_prefijo if (prefijo > 7599999)


    # Se veririca que el prefijo encontrado no este asignado a una empresa eliminada
    empresa_prefijo_invalido = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", prefijo])

      while (empresa_prefijo_invalido) # SI encontro registro se suma 1 y se verifica nuevamnete ese prefijo

        prefijo += 1
        empresa_prefijo_invalido = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", prefijo])
        
        if (empresa_prefijo_invalido.nil?) # Si no existe el prefijo en empresas eliminadas se busca en empresas activas

          empresa_prefijo_invalido = Empresa.find(:first, :conditions => ["prefijo = ?", prefijo])

        end
      end

    return prefijo

  end
  
  def self.busqueda_exhaustiva_prefijo

    # Este busqueda se puede optimizar aplicando algoritmo de BUSQUEDA BINARIA

    prefijos = Empresa.find_by_sql("Select prefijo from empresa  where (prefijo >= 7590001 and prefijo  <= 7599999) union select prefijo from empresa_eliminada where (prefijo >= 7590001 and prefijo  <= 7599999) order by prefijo")
    prefijos =  prefijos.map{|prefijo| prefijo.prefijo}

    for indice in (0..prefijos.size-2)
      break if ((prefijos[indice + 1] - prefijos[indice]) > 1)
    end
    
    return (prefijos[indice] + 1)

  end

  def self.agregar_contacto(contacto, empresa, tipo_contacto)

    empresa = Empresa.find(:first, :conditions => ["prefijo = ?", empresa])
    
    datos =  empresa.datos_contacto.first
    dato_contacto = DatosContacto.new 
    dato_contacto.prefijo = empresa.prefijo
    dato_contacto.tipo = tipo_contacto
    dato_contacto.contacto = contacto
    dato_contacto.nombre_contacto = datos.nombre_contacto
    dato_contacto.cargo_contacto = datos.cargo_contacto
    dato_contacto.save

  end


  def self.utilizar_prefijo_no_validado(empresa_no_validada)


    correspondencias = Correspondencia.find(:all, :conditions => ["prefijo = ?", empresa_no_validada.prefijo])
    correspondencias.collect{|correspondencia| correspondencia.prefijo = Empresa.generar_prefijo_valido; correspondencia.save }
    
    nuevo_prefijo_empresa_no_validada = Empresa.new
    nuevo_prefijo_empresa_no_validada.prefijo = Empresa.generar_prefijo_valido
    nuevo_prefijo_empresa_no_validada.nombre_empresa = empresa_no_validada.try(:nombre_empresa)
    nuevo_prefijo_empresa_no_validada.fecha_inscripcion = empresa_no_validada.try(:fecha_inscripcion)
    nuevo_prefijo_empresa_no_validada.direccion_empresa = empresa_no_validada.try(:direccion_empresa)
    nuevo_prefijo_empresa_no_validada.id_estado = empresa_no_validada.try(:id_estado)
    nuevo_prefijo_empresa_no_validada.id_ciudad = empresa_no_validada.try(:id_ciudad)
    nuevo_prefijo_empresa_no_validada.rif = empresa_no_validada.try(:rif)
    nuevo_prefijo_empresa_no_validada.id_estatus = empresa_no_validada.try(:id_estatus)
    nuevo_prefijo_empresa_no_validada.id_tipo_usuario = empresa_no_validada.try(:id_tipo_usuario)
    nuevo_prefijo_empresa_no_validada.nombre_comercial = empresa_no_validada.try(:nombre_comercial)
    nuevo_prefijo_empresa_no_validada.id_clasificacion = empresa_no_validada.try(:id_clasificacion)
    nuevo_prefijo_empresa_no_validada.categoria = empresa_no_validada.try(:categoria)
    nuevo_prefijo_empresa_no_validada.division = empresa_no_validada.try(:division)
    nuevo_prefijo_empresa_no_validada.grupo = empresa_no_validada.try(:grupo)
    nuevo_prefijo_empresa_no_validada.clase = empresa_no_validada.try(:clase)
    nuevo_prefijo_empresa_no_validada.rep_legal = empresa_no_validada.try(:rep_legal)
    nuevo_prefijo_empresa_no_validada.cargo_rep_legal = empresa_no_validada.try(:cargo_rep_legal)
    nuevo_prefijo_empresa_no_validada.circunscripcion_judicial = empresa_no_validada.try(:circunscripcion_judicial)
    nuevo_prefijo_empresa_no_validada.numero_registro_mercantil = empresa_no_validada.try(:numero_registro_mercantil)
    nuevo_prefijo_empresa_no_validada.tomo_registro_mercantil = empresa_no_validada.try(:tomo_registro_mercantil)
    nuevo_prefijo_empresa_no_validada.nit_registro_mercantil = empresa_no_validada.try(:nit_registro_mercantil)
    nuevo_prefijo_empresa_no_validada.nacionalidad_responsable_legal = empresa_no_validada.try(:nacionalidad_responsable_legal)
    nuevo_prefijo_empresa_no_validada.domicilio_responsable_legal = empresa_no_validada.try(:domicilio_responsable_legal)
    nuevo_prefijo_empresa_no_validada.cedula_responsable_legal = empresa_no_validada.try(:cedula_responsable_legal)
    nuevo_prefijo_empresa_no_validada.created_at = empresa_no_validada.try(:created_at)
    nuevo_prefijo_empresa_no_validada.updated_at = empresa_no_validada.try(:updated_at)
    nuevo_prefijo_empresa_no_validada.ventas_brutas_anuales = empresa_no_validada.try(:ventas_brutas_anuales)
    nuevo_prefijo_empresa_no_validada.fecha_registro_mercantil = empresa_no_validada.try(:fecha_registro_mercantil)
    nuevo_prefijo_empresa_no_validada.id_subestatus = empresa_no_validada.try(:id_subestatus)
    nuevo_prefijo_empresa_no_validada.fecha_activacion = empresa_no_validada.try(:fecha_activacion)
    prefijo_valido = Empresa.generar_prefijo_valido
    Gln.generar_legal(prefijo_valido.to_s)  
    empresa_no_validada.destroy
    nuevo_prefijo_empresa_no_validada.save

  end

end
