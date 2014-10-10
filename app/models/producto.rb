class Producto < ActiveRecord::Base
  self.table_name = "producto"  # El nombre de la tabla que se esta mapeando
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca, :prefijo, :codigo_upc, :fecha_retiro
  
  #has_one :productos_empresa,  :primary_key => "gtin",  :foreign_key => "gtin" ,  :dependent => :destroy # busca los productos en productos_empresa a traves de gtin no del campo  id
  #belongs_to :productos_empresa, :primary_key => "gtin",  :foreign_key => "gtin" # busca los productos en productos_empresa a traves de gtin no del campo  id
  
  belongs_to :empresa , :foreign_key => "prefijo"
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gtin, :foreign_key => "id_tipo_gtin"
  #has_one    :productos_retirados, :foreign_key => "gtin", :dependent => :destroy 

  validates :descripcion, :marca, :id_tipo_gtin, :presence => {:message => "No puede estar en blanco"}, :on => :create
  validates :gtin, :uniqueness => {:message => "El codigo de Producto que esta ingresando ya  se encuentra asociado a un GTIN"}


  def self.retirar(parametros) # Retira productos seleccionadaos individualmete

  	# Se busca el estatus retirado
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Retirado', 'Producto'])
    
    for retirar_producto in (0..parametros[:retirar_productos].size-1)
      producto_seleccionado = parametros[:retirar_productos][retirar_producto]
      retirar_datos = parametros[:"#{producto_seleccionado}"]
      gtin = retirar_datos.split('_')[0] # retirar_datos.split('_')[0] GTIN del producto retirar_datos.split('_')[1] id sub_estatus retirar_datos.split('_')[2] id motivo_retiro
      producto = Producto.find(:first, :conditions => ["gtin like ?", gtin])
      producto.id_estatus = estatus_producto.id 
      producto.save
      producto_retirado = ProductosRetirados.new 
      producto_retirado.gtin = producto.gtin
      producto_retirado.fecha_retiro = Time.now
      producto_retirado.id_motivo_retiro = retirar_datos.split('_')[2]
      producto_retirado.id_subestatus = retirar_datos.split('_')[1]
      producto_retirado.save 
      
    end
  
  end

  def self.retirar_productos_empresa(prefijo, motivo_retiro, sub_estatus) # Retira todos los producctos de una empresa dado su prefijo
    
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Retirado', 'Producto'])
    empresa = Empresa.find(:first, :conditions => ["prefijo = ?", prefijo])
    empresa.producto.collect{|producto|
    producto_ = Producto.find(:first, :conditions => ["gtin like ?", producto.gtin]);
    producto_.id_estatus = estatus_producto.id;
    producto_.save;
    producto_retirado = ProductosRetirados.new; 
    producto_retirado.gtin = producto_.gtin;
    producto_retirado.fecha_retiro = Time.now;
    producto_retirado.id_motivo_retiro = motivo_retiro;
    producto_retirado.id_subestatus = sub_estatus;
    producto_retirado.save 
    }
    

  end

  def self.eliminar(parametros)
  	
  	
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Eliminado', 'Producto'])
    
    #Los productos se agrega a productos eliminados y productos_elim_detalle, se eliminan de productos

    productos_eliminados = ""
    for eliminar_producto in (0..parametros[:eliminar_productos].size-1)

      producto_seleccionado = parametros[:eliminar_productos][eliminar_producto]

      producto = Producto.find(:first, :conditions => ["gtin like ?", producto_seleccionado])

      if producto.tipo_gtin.tipo == "GTIN-14" 
        
        productos = Producto.find(:all, :joins => [:producto], :conditions => ["prefijo = ? and codigo_prod = ? and id_tipo_gtin = ?",parametros[:empresa_id], producto.codigo_prod, producto.id_tipo_gtin], :select => "producto.*")  
      
      else
        productos = Producto.find(:all, :conditions => ["prefijo = ? and codigo_prod = ?",parametros[:empresa_id], producto.codigo_prod])
      end

      productos.collect{|producto| producto_elim_detalle = ProductoElimDetalle.new; producto_elim_detalle.gtin = producto.gtin; producto_elim_detalle.fecha_eliminacion = Time.now; producto_elim_detalle.save; productos_eliminados += producto.gtin; }
    
      productos.map{|producto| producto.destroy}
      
    end
    return productos

  	
  end

  def self.crear_gtin(tipo_gtin, prefijo, gtin, codigo_producto) # El gtin solo se pasa en el caso de la creacion de GTIN tipo 14
    
    
    tipo_gtin = TipoGtin.find(tipo_gtin)

    if tipo_gtin.tipo == "GTIN-8"            
     
      ultimo_gtin_asignado = Producto.find(:first, :conditions => ["producto.id_tipo_gtin = ?", tipo_gtin], :order => "producto.codigo_prod desc")

      secuencia = ultimo_gtin_asignado.gtin[3..6]  # N-1 digitos primeros digitos del último gtin8 asignado
      secuencia = (secuencia.to_i + 1) 

      secuencia_siguiente = completar_secuencia(secuencia, tipo_gtin.tipo) # Se completa con ceros a la izquierda si la secuecnia es menor 5 digitos
      
      secuencia_completa = "759" + secuencia_siguiente.to_s 
      digito_verificacion = calcular_digito_verificacion(secuencia_completa.to_i, "GTIN-8")
      gtin_generado =  secuencia_completa.to_s + digito_verificacion.to_s # 759 + secuencia + verificacion
      

    elsif tipo_gtin.tipo == "GTIN-13"

      if (codigo_producto.nil?) #No estan pasando el codigo de producto

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
        
        gtin = prefijo.to_s + secuencia

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
      
      
      if tipo_gtin.base == "GTIN-13"
        
        #productos = Producto.find(:all, :conditions => ["id_tipo_gtin = ? and gtin like ? and prefijo = ?",tipo_gtin.id, "%#{gtin[0..11]}%", prefijo])

        indicador = 1

        #numeracion_producto = productos.nil? ? 1 : (productos.size + 1)

        gtin_valido_generado = indicador.to_s + gtin[0..11]

        #raise numeracion_producto.to_yaml
        #gtin_valido_generado = productos.nil? ? (numeracion_producto.to_s + gtin[0..11]) : (numeracion_producto.to_s + gtin[0..11])
        
        
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
    elsif tipo_gtin == "GTIN-13"
     
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

  def self.import(file, tipo_gtin, prefijo) #Importar GTIN 13


    spreadsheet = open_spreadsheet(file)
    
    (2..spreadsheet.last_row).each do |fila|  # EL indice 1 es para indicar los datos de cabecera MARCA, DESCRIPCION, ETC
      
      productos_gtin_13_codificados = @productos_gtin_13 = Producto.find(:all, :conditions => ["tipo_gtin.tipo = ? and prefijo = ?", "GTIN-13", prefijo], :include => [:tipo_gtin]) if prefijo.to_s.size == 5

      break if (productos_gtin_13_codificados.size >= 10) and (prefijo.to_s.size == 5)

      if spreadsheet.empty?(fila,1) # EL codigo de producto no viene en el Excel

        gtin = Producto.crear_gtin(tipo_gtin,prefijo,nil, nil)

      else

        gtin = Producto.crear_gtin(tipo_gtin, prefijo, nil, spreadsheet.row(fila)[0].to_i)
        
      end


      producto = new
      producto.gtin = gtin.to_s
      producto.descripcion =   spreadsheet.empty?(fila,1) ? spreadsheet.row(fila)[1] :  spreadsheet.row(fila)[2]
      producto.marca =   spreadsheet.empty?(fila,1) ? spreadsheet.row(fila)[0] :  spreadsheet.row(fila)[1] 
      producto.id_estatus = 3
      producto.fecha_creacion = Time.now

      if prefijo.to_s.size == 7 or prefijo.to_s.size == 5

        producto.codigo_prod = producto.gtin[7..11]

      elsif prefijo.to_s.size == 9 and prefijo.to_s[3..5] == "400" # GTIN artesanal

        producto.codigo_prod = producto.gtin[9..11]

      end

      producto.id_tipo_gtin = tipo_gtin.to_i
      producto.prefijo = prefijo
      producto.save




      

    end


  end


  def self.import_gtin_14(file, tipo_gtin_, prefijo) #Importar GTIN 14

    tipo_gtin = TipoGtin.find(tipo_gtin_)

    spreadsheet = open_spreadsheet(file)

    codigo_invalido = nil

    (2..spreadsheet.last_row).each do |fila|

      gtin_existente =  verificar_gtin_existente(tipo_gtin.base, prefijo,spreadsheet.row(fila)[0].to_i )

      if (gtin_existente)

        gtin = crear_gtin_14(spreadsheet.row(fila)[1].to_i, gtin_existente.gtin, tipo_gtin.base)

        producto = new
        producto.gtin = gtin.to_s
        producto.descripcion = spreadsheet.row(fila)[3]
        producto.marca = spreadsheet.row(fila)[2]
        producto.id_estatus = 3
        producto.fecha_creacion = Time.now
        producto.codigo_prod = ((tipo_gtin.base == "GTIN-13") ? producto.gtin[8..12] : producto.gtin[9..12])
        producto.id_tipo_gtin = tipo_gtin_.to_i
        producto.prefijo = prefijo
        producto.save
        
        
        
      else

        codigo_invalido += " "+  spreadsheet.row(fila)[0].to_i.to_s
       
      end

    end

    return codigo_invalido

  end

  
  def self.verificar_gtin_existente(base, prefijo,codigo_producto)

    codigo_interno = completar_secuencia(codigo_producto, base)

    if base == "GTIN-13"

      gtin_generado =  prefijo.to_s + codigo_interno.to_s
    
    elsif base == "GTIN-8"
      gtin_8 = "759" + codigo_interno.to_s
      
    end

    digito_verificacion = calcular_digito_verificacion(gtin_generado.to_i, "GTIN-14")
    gtin_generado = gtin_generado + digito_verificacion.to_s

    gtin_existente = Producto.find(:first, :conditions => ["prefijo = ? and gtin = ?", prefijo, gtin_generado])
    return gtin_existente
  end

  

  def self.crear_gtin_14(secuencia, gtin, base)
    
    if base == "GTIN-13"

      gtin_generado = secuencia.to_s + gtin[0..11]
    
    elsif base == "GTIN-8"
      
      gtin_generado = secuencia.to_s + "00000" + gtin[0..6]

    end

    digito_verificacion = calcular_digito_verificacion(gtin_generado.to_i, "GTIN-14")
    gtin_generado = gtin_generado + digito_verificacion.to_s
    
    return gtin_generado

  end


  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Solo se permite importar archivo con extension '.xlsx', '.xls' : #{file.original_filename}"
    end
  end


end
