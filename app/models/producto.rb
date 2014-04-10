class Producto < ActiveRecord::Base
  self.table_name = "producto"  # El nombre de la tabla que se esta mapeando
  attr_accessible :codigo_prod, :descripcion, :fecha_creacion, :gpc, :gtin, :id_estatus, :id_tipo_gtin, :marca
  belongs_to :productos_empresa, :primary_key => "gtin",  :foreign_key => "gtin" # busca los productos en productos_empresa a traves de gtin no del campo  id
  belongs_to :estatus, :foreign_key => "id_estatus"
  belongs_to :tipo_gtin, :foreign_key => "id_tipo_gtin"

  def self.retirar(productos)

  	# Se busca el estatus retirado
    estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Retirado', 'Producto'])
    
    #Los productos pasan a estatus retirado y se agregan a la tabla productos_retirados 
    productos.collect{|producto| producto = Producto.find(:first, :conditions => ["gtin like ?", producto]); producto_retirado = ProductosRetirados.new; producto_retirado.gtin = producto.gtin; producto_retirado.fecha_retiro = Time.now; producto_retirado.save; producto.id_estatus = estatus_producto.id; producto.save}
  
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
