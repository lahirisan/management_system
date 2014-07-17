class ModificarProductoEliminadoCodigoProducto < ActiveRecord::Migration
  def change
    change_column :producto_eliminado, :codigo_prod, :string
    
  end
end
