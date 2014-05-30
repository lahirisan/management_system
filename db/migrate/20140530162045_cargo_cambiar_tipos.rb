class CargoCambiarTipos < ActiveRecord::Migration
  def change
    change_column :cargo, :descripcion, :string
  end
end
