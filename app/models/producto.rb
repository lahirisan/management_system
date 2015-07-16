class Producto < ActiveRecord::Base
  self.table_name = "producto"  # El nombre de la tabla que se esta mapeando
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca, :prefijo, :codigo_upc, :fecha_retiro, :fecha_ultima_modificacion
  
  belongs_to :empresa , :foreign_key => "prefijo"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gtin, :foreign_key => "id_tipo_gtin"
  
  validates :descripcion, :marca, :id_tipo_gtin, :presence => {:message => "No puede estar en blanco"}, :on => :create
  validates :gtin, :uniqueness => {:message => "El codigo de Producto que esta ingresando ya  se encuentra asociado a un GTIN"}


  
  # Exportar CSV formato auditoria Service Retail


  def self.csv_auditoria_service_retail_producto
    
    CSV.generate(:col_sep => ";") do |csv|
        
        Producto.joins(:empresa).select("producto.prefijo, empresa.rif_completo, producto.gtin, producto.descripcion, producto.id_estatus").find_each(batch_size: 50000) do |producto|
          
          producto_estatus_activo = (producto.id_estatus == 3) ? "SI" : "NO"
          producto_estatus_retirado = (producto.id_estatus == 4) ? "SI" : "NO"

          
          csv << [producto.prefijo, producto.try(:rif_completo), producto.gtin, producto.descripcion, producto_estatus_activo, producto_estatus_retirado]

        end
    end

  end

  def self.retirar(parametros) # Retira productos desde el listado de productos

  	# Se busca el estatus retirado
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Retirado', 'Producto'])
    
    for retirar_producto in (0..parametros[:retirar_productos].size-1)
      producto_seleccionado = parametros[:retirar_productos][retirar_producto]
      retirar_datos = parametros[:"#{producto_seleccionado}"]
      gtin = retirar_datos.split('_')[0] # retirar_datos.split('_')[0] GTIN del producto retirar_datos.split('_')[1] id sub_estatus retirar_datos.split('_')[2] id motivo_retiro
      producto = Producto.find(:first, :conditions => ["gtin like ?", gtin])
      producto.id_estatus = estatus_producto.id 
      producto.fecha_retiro = Time.now
      producto.save
      #Auditoria.registrar_evento(session[:usuario],"producto", "Retirar", Time.now,  "PRODUCTO RETIRADO. GTIN:#{producto.gtin}")
      
    end
  
  end

  def self.retirar_productos(prefijo) # Retira todos los producctos de una empresa dado su prefijo
    
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Retirado', 'Producto'])
   
    productos = Producto.find(:all, :conditions => ["prefijo = ?", prefijo])
    productos.collect{|producto|
    producto.id_estatus = estatus_producto.id;
    producto.fecha_retiro = Time.now;
    producto.save
    #Auditoria.registrar_evento(session[:usuario],"producto", "Retirar", Time.now,  "PRODUCTO RETIRADO. GTIN:#{producto.gtin}")
    
    }


  end

  def self.eliminar(parametros)
  	
  	
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Eliminado', 'Producto'])
    
    #Los productos se agrega a productos eliminados y productos_elim_detalle, se eliminan de productos

    productos_eliminados = []
    for eliminar_producto in (0..parametros[:eliminar_productos].size-1)

      producto_seleccionado = parametros[:eliminar_productos][eliminar_producto]

      producto = Producto.find(:first, :conditions => ["gtin like ?", producto_seleccionado])

      if producto
        if producto.tipo_gtin.tipo == "GTIN-14" 
          
          producto_eliminar = Producto.find_by(gtin: producto.gtin)  
          producto_eliminar.destroy
          productos_eliminados << producto.gtin
        else
          productos = Producto.find(:all, :conditions => ["prefijo = ? and codigo_prod = ?",parametros[:empresa_id], producto.codigo_prod])
          productos.map{|producto_eliminar| producto_eliminar.destroy; productos_eliminados << producto_eliminar.gtin}
        end

        # TODO: La traza de la infromacion del usaurio y los producvtos que esta eliminando
        
        
      end
      
    end
    return productos_eliminados

  	
  end

  def self.crear_gtin(tipo_gtin, prefijo, gtin, codigo_producto) # El gtin solo se pasa en el caso de la creacion de GTIN tipo 14
    
    
    tipo_gtin = TipoGtin.find(tipo_gtin)

    if tipo_gtin.tipo == "GTIN-8"            
     
      if (codigo_producto.nil?)

        ultimo_gtin_asignado = Producto.find(:first, :conditions => ["producto.id_tipo_gtin = ?", tipo_gtin], :order => "producto.codigo_prod desc")

        secuencia = ultimo_gtin_asignado.gtin[3..6]  # N-1 digitos primeros digitos del último gtin8 asignado
        secuencia = (secuencia.to_i + 1) 

        secuencia_siguiente = completar_secuencia(secuencia, tipo_gtin.tipo) # Se completa con ceros a la izquierda si la secuecnia es menor 5 digitos
        secuencia_completa = "759" + secuencia_siguiente.to_s 

      else
        secuencia_completa = "759" + codigo_producto.to_s
        
      end

        digito_verificacion = calcular_digito_verificacion(secuencia_completa.to_i, "GTIN-8")
        gtin_generado =  secuencia_completa.to_s + digito_verificacion.to_s # 759 + secuencia + verificacion
        

    elsif tipo_gtin.tipo == "GTIN-13"

      if (codigo_producto.nil?) #No estan pasando el codigo de producto tipo de creacion automatica

        producto =  Producto.find(:first, :conditions => ["id_tipo_gtin = ? and prefijo = ?", tipo_gtin, prefijo], :order => "codigo_prod desc")

        if (producto) 

          if producto.codigo_prod == '99999' and (prefijo.to_s.size == 7 or prefijo.to_s.size == 5)
            
            secuencia = "00001"

          elsif producto.codigo_prod == '999' and prefijo.to_s.size == 9
            
            secuencia = "001"  # GTIN ARtesanal
          
          else
            secuencia = producto.codigo_prod.strip
          end

        else # La empresa no tiene productos

          if prefijo.to_s.size == 7 or prefijo.to_s.size == 5
            secuencia = "00001"
          elsif prefijo.to_s.size == 9 and prefijo.to_s[3..5] == "400" # GTIN artesanal
            secuencia = "001"
          end

        end
        
      else # ASignacion manual del codigo de producto
        
        secuencia = codigo_producto
      end

      
      if prefijo.to_s.size == 7

        gtin = completar_secuencia(secuencia, tipo_gtin.tipo) 

        gtin = prefijo.to_s + gtin.to_s

      elsif prefijo.to_s.size == 9 and prefijo.to_s[3..5] == "400" # GTIN artesanal
        
        gtin = prefijo.to_s + secuencia.to_s

      elsif prefijo.to_s.size == 5

        secuencia = completar_secuencia(secuencia, tipo_gtin.tipo) 
        gtin = "7599000" + secuencia.to_s

      end


      digito_verificacion = calcular_digito_verificacion(gtin.to_i, "GTIN-13")
      gtin_generado = gtin.to_s + digito_verificacion.to_s

      codigo_asignado = Producto.find(:first, :conditions => ["gtin = ? ", gtin_generado])

      while (codigo_asignado and codigo_producto.nil?) do 

        gtin = gtin.to_i + 1
        digito_verificacion = calcular_digito_verificacion(gtin.to_i, "GTIN-13")
        gtin_generado = gtin.to_s + digito_verificacion.to_s
        codigo_asignado = Producto.find(:first, :conditions => [" gtin = ? ", gtin_generado])
       
      end
      
    elsif tipo_gtin.tipo == "GTIN-14"  

      if tipo_gtin.base == "GTIN-13" # generacion de GTIN-14 en base a GTIN-13
        
        indicador = 1

        gtin_valido_generado = indicador.to_s + gtin[0..11]

        
        digito_verificacion = calcular_digito_verificacion(gtin_valido_generado.to_i, "GTIN-14") 
        gtin_generado = gtin_valido_generado.to_s + digito_verificacion.to_s


        while (Producto.find(:first, :conditions => ["id_tipo_gtin = ? and gtin = ? and prefijo = ?",tipo_gtin.id, gtin_generado, prefijo])) do 

          indicador +=  1
          gtin_valido_generado = indicador.to_s + gtin[0..11]
          digito_verificacion = calcular_digito_verificacion(gtin_valido_generado.to_i, "GTIN-14") 
          gtin_generado = gtin_valido_generado.to_s + digito_verificacion.to_s
          
        end


      elsif tipo_gtin.base == "GTIN-8"
        
        productos = Producto.find(:all, :conditions => ["producto.id_tipo_gtin = ? and producto.gtin like ?",tipo_gtin.id, "%#{gtin[0..6]}%"])
        numeracion_producto = productos.nil? ? 1 : (productos.size + 1)
        gtin_valido_generado = (numeracion_producto.to_s + "00000" + gtin[0..6]) 
        digito_verificacion = calcular_digito_verificacion(gtin_valido_generado.to_i, "GTIN-14")
        gtin_generado = gtin_valido_generado.to_s + digito_verificacion.to_s 


      elsif tipo_gtin.base == "GTIN-12"

        producto_original = Producto.find(gtin)
        
        
        # Se buscan la cantidad de GTIN14 existentes para ese GTIN
        productos = Producto.where(prefijo: producto_original.prefijo, id_tipo_gtin: tipo_gtin.id, codigo_prod: producto_original.codigo_prod)
        
        

        numeracion_producto = productos.nil? ? 1 : (productos.size + 1)
        gtin_valido_generado = (numeracion_producto.to_s + "0" + gtin[0..10]) 
        digito_verificacion = calcular_digito_verificacion(gtin_valido_generado.to_i, "GTIN-14")
        gtin_generado = gtin_valido_generado.to_s + digito_verificacion.to_s

        
        
      end
        
      


      
    end

    return gtin_generado

  end

  def self.calcular_digito_verificacion(dividendo,tipo_gtin)

    rango = 6..0 if tipo_gtin == "GTIN-8"
    rango = 11..0 if tipo_gtin == "GTIN-13"
    rango = 12..0 if tipo_gtin == "GTIN-14"

    acumulado = 0
    
    (rango.first).downto(rango.last).each{ |iteracion| 
      digito = (dividendo / (10 ** iteracion));
      dividendo = (dividendo % (10 ** iteracion));
     
        acumulado += ((iteracion % 2)  == 0) ? (digito * 3) : digito
      
    }

    # SI el acumulado es multiplo de 10 se retorna 0
    verificacion = ((acumulado % 10) == 0) ? 0 : (((acumulado / 10) +1) * 10) - acumulado  # decena superior - acumulado

    return verificacion 

  end

  
  def self.completar_secuencia(secuencia, tipo_gtin)
     
     

    if tipo_gtin == "GTIN-8"
      if secuencia.to_s.size == 1
        secuencia = "000" + secuencia.to_s 
      elsif secuencia.to_s.size == 2
        secuencia = "00" + secuencia.to_s 
      elsif secuencia.to_s.size == 3
        secuencia = "0" + secuencia.to_s
      end
    elsif (tipo_gtin == "GTIN-13") 
      
      if secuencia.to_s.size == 1 
        secuencia = "0000" + secuencia.to_s 
      elsif secuencia.to_s.size == 2
        secuencia = "000" + secuencia.to_s 
      elsif secuencia.to_s.size == 3
        secuencia = "00" + secuencia.to_s
      elsif secuencia.to_s.size == 4
        secuencia = "0" + secuencia.to_s
      end
      
    end


    return secuencia

  end


  def self.completar_prefijo(secuencia, prefijo_empresa)

    if prefijo_empresa.to_s.size == 5
      gtin = prefijo_empresa.to_s + "00" + secuencia.to_s 
    elsif prefijo_empresa.to_s.size == 6
      gtin = prefijo_empresa.to_s + "0" + secuencia.to_s 
    elsif prefijo_empresa.to_s.size == 7
      gtin = prefijo_empresa.to_s +  secuencia.to_s 
    end
    return gtin

  end

  


  def self.import_gtin_14(file, original_file_name, tipo_gtin_, prefijo, usuario) #Importar GTIN 14

    tipo_gtin = TipoGtin.find(tipo_gtin_)
    spreadsheet = Empresa.open_spreadsheet(file, original_file_name)

    codigo_invalido = ""

    (2..spreadsheet.last_row).each do |fila|

      # Se verifica si el gtin base existe

      gtin_existente =  verificar_gtin_existente(tipo_gtin.base, prefijo,spreadsheet.row(fila)[0].to_i )

      if (gtin_existente)

        gtin = crear_gtin_14(spreadsheet.row(fila)[1].to_i, gtin_existente.gtin, tipo_gtin.base)

        producto = new
        producto.gtin = gtin.to_s
        producto.descripcion = spreadsheet.row(fila)[3]
        producto.marca = spreadsheet.row(fila)[2]
        producto.id_estatus = 3
        producto.fecha_creacion = Time.now 
        

        if (tipo_gtin.base == "GTIN-13" and prefijo.to_s.size == 7)

          producto.codigo_prod =  producto.gtin[8..12]  

        elsif  (tipo_gtin.base == "GTIN-8" and prefijo.to_s.size == 7)

          producto.codigo_prod = producto.gtin[9..12]

        elsif (tipo_gtin.base == "GTIN-13" and prefijo.to_s.size == 9 and prefijo.to_s[3..5] == "400") # GTIN artesanal

          producto.codigo_prod = producto.gtin[10..12]

        elsif tipo_gtin.base == "GTIN-12"

          producto.codigo_prod = producto.gtin[8..12]

        end

        producto.id_tipo_gtin = tipo_gtin_.to_i
        producto.prefijo = prefijo
        
        # SE verifica si el producto existe en cuyo caso se notifica al usuario

        producto_verificado = Producto.find(:first, :conditions => ["prefijo = ? and gtin = ?", prefijo, producto.gtin])
        codigo_invalido += " "+  producto_verificado.gtin if producto_verificado 
        producto.save  

        Auditoria.registrar_evento(usuario,"producto", "Importar", Time.now, "GTIN:#{producto.gtin} DESCRIPCION:#{producto.descripcion} TIPO:GTIN-14")
        
      else
        
        
        codigo_invalido += " "+  spreadsheet.row(fila)[0].to_i.to_s
       
      end

    end

    return codigo_invalido

  end

  
  def self.verificar_gtin_existente(base, prefijo,codigo_producto) # Si se sta generando GTIN14 base 12 en el parametro codigo_producto va el GTIN12 que se va a transformar en GTIN13



    if prefijo.to_s.size == 7 or prefijo.to_s.size == 5
      # Se completa el codigo interno de lo que indica el archivo excel a 5 digitos, el naso de GTIN14 base 12 el codigo interno es el mismo GTIN12 que deberia venir en el EXCEL

      codigo_interno = completar_secuencia(codigo_producto, base) 

    else
      codigo_producto = "00" + codigo_producto.to_s if codigo_producto.to_s.size == 1
      codigo_producto = "0" + codigo_producto.to_s if codigo_producto.to_s.size == 2
      codigo_interno = codigo_producto

    end


    if base == "GTIN-13"

      gtin_generado =  prefijo.to_s + codigo_interno.to_s
    
    elsif base == "GTIN-8"
      gtin_generado = "759" + codigo_interno.to_s
   
    end

    if (base == "GTIN-13") or (base == "GTIN-8")

      digito_verificacion = calcular_digito_verificacion(gtin_generado.to_i, base)
      gtin_generado = gtin_generado + digito_verificacion.to_s

    end

    gtin_generado = codigo_producto.to_s if base == "GTIN-12"

    # Se verifica si existe el GTIN    
    gtin_existente = Producto.find(:first, :conditions => ["prefijo = ? and gtin = ?", prefijo, gtin_generado])

    
    return gtin_existente
  end

  

  def self.crear_gtin_14(secuencia, gtin, base)
    

    if base == "GTIN-13"

      gtin_generado = secuencia.to_s + gtin[0..11]
    
    elsif base == "GTIN-8"
      
      gtin_generado = secuencia.to_s + "00000" + gtin[0..6]

    elsif base == "GTIN-12"
      
      gtin_generado = secuencia.to_s + "0" + gtin[0..10]

    end


    digito_verificacion = calcular_digito_verificacion(gtin_generado.to_i, "GTIN-14")
    gtin_generado = gtin_generado + digito_verificacion.to_s

    
    return gtin_generado

  end


  

  def self.transferir_gtin(productos, empresa)

    # Se transfiere los productos y se marca su estatus como activo
    
    Producto.where("gtin in (?)", productos.collect{|producto| producto}).update_all("prefijo = #{empresa[0]}, id_estatus = 3")
    
    # Se transfiere los GTIN-14 asociados
    #productos_ = Producto.find(productos)
    #productos_.each{|producto| Producto.where("prefijo = producto.prefijo and codigo_prod = #{producto.codigo_prod} and id_tipo_gtin = 4").update_all("prefijo = #{empresa[0]}")}
    
  end

  def self.eliminar_productos_desde_excel # Procedimiento para eliminar Productos

  spreadsheet = Roo::Excelx.new("#{Rails.root}/doc/PRODUCTOS_ELIMINAR.xlsx", nil, :ignore)

    no_se_encontro = []

    (1..spreadsheet.last_row).each do |fila|
       producto = Producto.find_by(gtin: spreadsheet.cell(fila,3).to_s)
        
        if producto.nil?
          no_se_encontro << spreadsheet.cell(fila,3)
        else
          producto.destroy
        end

    end

    raise no_se_encontro.to_yaml if no_se_encontro.any?


 end


end
