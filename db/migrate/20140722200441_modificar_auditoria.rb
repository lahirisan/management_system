class ModificarAuditoria < ActiveRecord::Migration
  def change
    rename_column :auditoria, :id_usuario, :usuario
    change_column :auditoria, :usuario, :string
    add_column    :auditoria, :descripcion, :string
  end
end
