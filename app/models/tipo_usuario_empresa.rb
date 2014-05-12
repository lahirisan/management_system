class TipoUsuarioEmpresa < ActiveRecord::Base
  attr_accessible :descripcion, :habilitador, :id_tipo_usu_empresa
  self.table_name = "tipo_usuario_empresa"  # El nombre de la tabla que se esta mapeando
  self.primary_key = "id_tipo_usu_empresa"
end
