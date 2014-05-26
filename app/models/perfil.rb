class Perfil < ActiveRecord::Base
  self.table_name = 'perfil_usuario_int'
  attr_accessible :descripcion, :detalle, :habilitado
end
