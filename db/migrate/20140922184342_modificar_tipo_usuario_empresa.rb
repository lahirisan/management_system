class ModificarTipoUsuarioEmpresa < ActiveRecord::Migration
  def change
    change_column :tipo_usuario_empresa, :descripcion, :string
  end 
end
