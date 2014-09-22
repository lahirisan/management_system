class EmpresaAgregarRegistroMercantil < ActiveRecord::Migration
  add_column :empresa, :fecha_registro_mercantil, :datetime
end
