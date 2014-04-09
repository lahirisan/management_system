class ApplicationController < ActionController::Base
  protect_from_forgery

  def retirar_productos(productos) # Este procedimiento es invocado em productos y en empresa
  	
  	# Se busca el estatus retirado
  	estatus_producto = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ?", 'Retirado', 'Producto'])
    
    #Los productos pasan a estatus retirado y se agregan a la tabla productos_retirados 
    productos.collect{|producto_empresa| producto = Producto.find(:first, :conditions => ["gtin like ?", producto_empresa.gtin]); producto_retirado = ProductosRetirados.new; producto_retirado.gtin = producto.gtin; producto_retirado.fecha_retiro = Time.now; producto_retirado.save; producto.id_estatus = estatus_producto.id; producto.save}

  end

end
