class ModificarTipoUsuario < ActiveRecord::Migration
  def change
    change_column :perfil_usuario_int, :descripcion, :string
    change_column :perfil_usuario_int, :detalle, :string
  end
end
