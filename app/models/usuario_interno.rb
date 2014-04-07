class UsuarioInterno < ActiveRecord::Base
  attr_accessible :username, :password_hash, :password_salt, :nombre_apellido, :email,:id_perfil, :id_gerencia, :id_cargo, :fecha_creacion
  self.table_name = "usuario_interno"  # El nombre de la tabla que se esta mapeando
end
