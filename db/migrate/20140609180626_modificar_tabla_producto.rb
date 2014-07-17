class ModificarTablaProducto < ActiveRecord::Migration
  def change
    change_column :producto, :codigo_prod, :string
    
  end
end
