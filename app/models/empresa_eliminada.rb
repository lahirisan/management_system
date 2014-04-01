class EmpresaEliminada < ActiveRecord::Base
  attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_status, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif
  self.table_name = "empresa_eliminada"  # El nombre de la tabla que se esta mapeando
end
