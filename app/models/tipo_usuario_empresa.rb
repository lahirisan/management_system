class TipoUsuarioEmpresa < ActiveRecord::Base
  attr_accessible :descripcion, :habilitado, :id_tipo_usu_empresa
  self.table_name = "tipo_usuario_empresa"  # El nombre de la tabla que se esta mapeando
end
