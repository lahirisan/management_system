class Producto < ActiveRecord::Base
  self.table_name = "producto"  # El nombre de la tabla que se esta mapeando
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca
  belongs_to :productos_empresa, :primary_key => "gtin",  :foreign_key => "gtin" # busca los productos en productos_empresa a traves de gtin no del campo  id
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gtin, :foreign_key => "id_tipo_gtin"
  has_one    :productos_retirados, :foreign_key => "gtin"

  def self.retirar(parametros)

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

  def self.eliminar(productos)
  	
  	estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Eliminado', 'Producto'])
    
    #Los productos se agrega a productos eliminados
    productos.collect{|producto_seleccionado|
    producto = Producto.find(:first, :conditions => ["gtin like ?", producto_seleccionado]) 
  	producto_eliminado = ProductoEliminado.new;
    producto_eliminado.gtin = producto.gtin; 
  	producto_eliminado.descripcion = producto.descripcion; 
  	producto_eliminado.marca = producto.marca; 
  	producto_eliminado.gpc = producto.gpc; 
  	producto_eliminado.id_estatus = estatus_producto.id; 
  	producto_eliminado.codigo_prod = producto.codigo_prod; 
  	producto_eliminado.fecha_creacion = Time.now; 
  	producto_eliminado.id_tipo_gtin =producto.id_tipo_gtin; 
  	producto_eliminado.save; 
    producto_elim_detalle = ProductoElimDetalle.new; 
  	producto_elim_detalle.gtin = producto.gtin; 
  	producto_elim_detalle.fecha_eliminacion = Time.now; 
  	producto_elim_detalle.save}

  	# Se elimina los productos de la empresa
  	productos.collect{|producto| producto = Producto.find(:first, :conditions => ["gtin like ?", producto]); producto.destroy}
  	
  end

end
