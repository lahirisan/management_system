class AgregarCampoFechaReactivacion < ActiveRecord::Migration
  add_column :empresa, :fecha_reactivacion, :datetime
end
