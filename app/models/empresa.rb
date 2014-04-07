class Empresa < ActiveRecord::Base
  self.table_name = "empresa"  # El nombre de la tabla que se esta mapeando
  set_primary_key "prefijo" # Se establece la clave primaria
  
  has_one :correspondencia, :foreign_key => "prefijo"
  accepts_nested_attributes_for :correspondencia, :allow_destroy => true # Maneja el modelo correspondencia en el formulario de empresa
  attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_estatus, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif, :prefijo,  :correspondencia_attributes # Los atributos de correspondecia
  
  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"  
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion"
  has_one  :empresas_retiradas,  :foreign_key => "prefijo" , :dependent => :destroy   # Define una asociacion 1 a 1 con empresas_retiradas, eliminacion en cascada
  has_many :productos_empresa, :foreign_key => "prefijo" # Define una asociaicion 1 a N con productos_empresa
  has_many :producto, :through => :productos_empresa, :foreign_key => "prefijo" # Define una asociaicion 1 a N con productos_empresa

  
  validates :nombre_empresa, :fecha_inscripcion, :direccion_empresa, :id_estado, :id_ciudad, :rif, :prefijo,   :presence => {:message => "No puede estar en blanco"}
  validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{8})-([0-9]{1})$/, on: :create, :message => "El Formato del RIF es invalido"} # Validacion al crear
  #validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{8})-([0-9]{1})$/, on: :update, :message => "El Formato del RIF es invalido"} # Validacion al editar

  def self.to_csv # Se genera el CSV de Empresas

  	CSV.generate do |csv|
  		all.each do |empresa|
  			csv << empresa.attributes.values_at(*column_names)
  		end
    end 
  end

  def self.validar_empresas(empresas) # Procedimiento para validar Empresas
    @estatus_activa = Estatus.find(:first, :conditions => ["descripcion like ?", "Activa"]) # Se busca el ID de Estatus Activa
    @empresas = Empresa.find(:all, :conditions => ["prefijo in (?)", empresas.collect{|prefijo| prefijo}])
    @empresas.collect{|empresa_seleccionada| empresa = Empresa.find(empresa_seleccionada.prefijo); empresa.id_estatus = @estatus_activa.id; empresa.save}
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
        empresa_retirar.id_motivo_retiro = retirar_datos.split('_')[2]
        empresa_retirar.id_subestatus = retirar_datos.split('_')[1]
        empresa_retirar.save
        
        empresa = Empresa.find(retirar_datos.split('_')[0]) # La clave primaria es es prefijo
        # El estatus de retirada Se cambia el estatus de la empresa
        estatus_retirada = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", 'Retirada', 'Empresa'])
        empresa.id_estatus = estatus_retirada.id
        empresa.save

        estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Retirado', 'Producto'])
        #Los productos se agrega a productos retirados 
        empresa.productos_empresa.collect{|producto_empresa| producto = Producto.find(:first, :conditions => ["gtin like ?", producto_empresa.gtin]); producto_retirado = ProductosRetirados.new; producto_retirado.gtin = producto.gtin; producto_retirado.fecha_retiro = Time.now; producto_retirado.save; producto.id_estatus = estatus_producto.id; producto.save}
        
      end
  end

  def self.eliminar_empresas(parametros)
    
    #En el parametro activar empresa estan cada uno de los ID de las empresas que se van a retirar. A su vez ese es el nombre del input asociado a la empresa y tiene el valor de los campos sub-estatus y motivo-retiro
    # OJO: Esto se peude optimizar actualizando masivamente // RailsCast 198

      for eliminar_empresas in (0..parametros[:eliminar_empresas].size-1)
        empresa_seleccionada = parametros[:eliminar_empresas][eliminar_empresas]
        eliminar_datos = parametros[:"#{empresa_seleccionada}"]
        eliminar_datos.split('_')[0] # eliminar_datos.split('_')[0] Prefijo de la empresa eliminar_datos.split('_')[1] id sub_estatus eliminar_datos.split('_')[2] id motivo_retiro
        
        # Se busca la empresa para obtener todos sus datos
        empresa_eliminar = Empresa.find(:first, :conditions => ["prefijo = ?",eliminar_datos.split('_')[0]])
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
        empresa_eliminada.id_motivo_retiro = eliminar_datos.split('_')[2]
        empresa_eliminada.id_subestatus = eliminar_datos.split('_')[1]
        empresa_eliminada.save

        empresa_eliminada_detalle = EmpresaElimDetalle.new
        empresa_eliminada_detalle.prefijo = empresa_eliminada.prefijo
        empresa_eliminada_detalle.fecha_eliminacion = Time.now
        empresa_eliminada_detalle.save

        
        estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Eliminado', 'Producto'])
        #Los productos se agrega a productos eliminados
        empresa_eliminar.productos_empresa.collect{|producto_empresa| 
          producto_eliminado = ProductoEliminado.new; 
          producto_eliminado.gtin = producto_empresa.producto.gtin; 
          producto_eliminado.descripcion = producto_empresa.producto.descripcion; 
          producto_eliminado.marca = producto_empresa.producto.marca; 
          producto_eliminado.gpc = producto_empresa.producto.gpc; 
          producto_eliminado.id_estatus = estatus_producto.id; 
          producto_eliminado.codigo_prod = producto_empresa.producto.codigo_prod; 
          producto_eliminado.fecha_creacion = Time.now; 
          producto_eliminado.id_tipo_gtin = producto_empresa.producto.id_tipo_gtin; 
          producto_eliminado.save; producto_elim_detalle = ProductoElimDetalle.new; 
          producto_elim_detalle.gtin = producto_empresa.producto.gtin; 
          producto_elim_detalle.fecha_eliminacion = Time.now; 
          producto_elim_detalle.save}
        # Se elimina los productos de la empresa
        empresa_eliminar.productos_empresa.collect{|productos_empresa| producto = Producto.find(:first, :conditions => ["gtin like ?", productos_empresa.gtin]); producto.destroy}
        # Se elimina lña empresa
        empresa_eliminar.destroy

      end
  end
  
  def self.reactivar_empresas_eliminadas(parametros)
    
    estatus_empresa = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Activa', 'Empresa'])
    
    # reactivacion de las empresasa
    for eliminada in (0..parametros[:reactivar_empresas].size-1)
      empresa_reactivada = Empresa.new
      empresa_eliminada = EmpresaEliminada.find(:first, :conditions => ["prefijo like ?",parametros[:reactivar_empresas][eliminada]])
      empresa_reactivada.prefijo = empresa_eliminada.prefijo
      empresa_reactivada.nombre_empresa = empresa_eliminada.nombre_empresa
      empresa_reactivada.fecha_inscripcion = empresa_eliminada.fecha_inscripcion
      empresa_reactivada.direccion_empresa = empresa_eliminada.direccion_empresa.nil? ? 'No Tiene' : empresa_eliminada.direccion_empresa
      empresa_reactivada.id_estado = empresa_eliminada.id_estado 
      empresa_reactivada.id_ciudad = empresa_eliminada.id_ciudad
      empresa_reactivada.rif = empresa_eliminada.rif.strip # Elimina espacios en blanco
      empresa_reactivada.id_estatus = estatus_empresa.id
      empresa_reactivada.id_tipo_usuario = empresa_eliminada.id_tipo_usuario
      empresa_reactivada.nombre_comercial = empresa_eliminada.try(:nombre_comercial)
      empresa_reactivada.id_clasificacion = empresa_eliminada.try(:id_clasificacion)
      empresa_reactivada.categoria = empresa_eliminada.try(:categoria)
      empresa_reactivada.division = empresa_eliminada.try(:division)
      empresa_reactivada.grupo = empresa_eliminada.try(:grupo)
      empresa_reactivada.clase = empresa_eliminada.try(:clase)
      empresa_reactivada.rep_legal = empresa_eliminada.try(:rep_legal)
      empresa_reactivada.cargo_rep_legal = empresa_eliminada.try(:cargo_rep_legal)
      empresa_reactivada.save
      empresa_eliminada.destroy      
    end

    
    #reactivacion de los productos
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Activo', 'Producto'])
    # Se buscan los productos de las empresas
    
    for eliminada in (0..parametros[:reactivar_empresas].size-1)
      productos_empresas = ProductosEmpresa.find(:all, :conditions => ["prefijo like ?", parametros[:reactivar_empresas][eliminada]])

      for producto in (0.. productos_empresas.size-1)
        producto_eliminado = ProductoEliminado.find(:first, :conditions => ["gtin like ?",productos_empresas[producto].gtin])
        producto_activado = Producto.new
        producto_activado.gtin = producto_eliminado.gtin
        producto_activado.descripcion = producto_eliminado.descripcion
        producto_activado.marca = producto_eliminado.try(:marca)
        producto_activado.gpc = producto_eliminado.try(:gpc)
        producto_activado.id_estatus = estatus_producto.id
        producto_activado.codigo_prod = producto_eliminado.try(:codigo_prod)
        producto_activado.fecha_creacion = producto_eliminado.try(:fecha_creacion)
        producto_activado.id_tipo_gtin = producto_eliminado.try(:id_tipo_gtin)
        producto_activado.save
        producto_eliminado.destroy

      end
    
    end

  end

  def self.reactivar_empresas_retiradas(parametros)
    
    estatus_empresa = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Activa', 'Empresa'])
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Activo', 'Producto'])

    empresas_retiradas = Empresa.find(parametros[:reactivar_empresas]) # Se busca la empresa
    empresas_retiradas.collect{|empresa| empresa.id_estatus = estatus_empresa.id; empresa.save; empresa_retirada = EmpresasRetiradas.find(:first, :conditions => ["prefijo like ?", empresa.prefijo]); empresa_retirada.destroy; empresa.productos_empresa.collect{|producto_empresa| producto = Producto.find(producto_empresa.gtin); producto.id_estatus = estatus_producto.id;producto.save; producto_retirado = ProductosRetirados.find(:first, :conditions =>["gtin like ?",producto_empresa.gtin]); producto_retirado.destroy;}} 
 
  end

end
