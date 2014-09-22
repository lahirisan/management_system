class ModificarTablaEmpresaIdTipoUsuario < ActiveRecord::Migration
   def change
    change_column :empresa, :id_tipo_usuario, :string
    
  end
end
