class AgregarSusbEstatusEmpresasActivas < ActiveRecord::Migration
  add_column :empresa, :id_subestatus, :integer
end
