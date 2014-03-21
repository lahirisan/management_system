class CreateTipoUsuarioEmpresas < ActiveRecord::Migration
  def change
    create_table :tipo_usuario_empresas do |t|
      t.integer :id_tipo_usu_empresa
      t.string :descripcion
      t.boolean :habilitado

      t.timestamps
    end
  end
end
