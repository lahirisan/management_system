class Usuario < ActiveRecord::Base
  attr_accessible :email, :fecha_creacion, :id_cargo, :id_gerencia, :id_perfil, :nombre_apellido, :password, :username
  self.table_name = "usuario_interno" # nombre de la tabla asociadoa en el sistema administrativo
end
