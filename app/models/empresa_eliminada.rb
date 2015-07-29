class EmpresaEliminada < ActiveRecord::Base
  attr_accessible :rep_legal, :categoria, :clase, :division, :grupo,  :id_estatus, :id_tipo_usuario, :nombre_empresa, :rif, :id_motivo_retiro, :no_elegible
  self.table_name = "empresa_eliminada"  # El nombre de la tabla que se esta mapeando
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"
  belongs_to :tipo_usuario_empresa, :foreign_key => "id_tipo_usuario_empresa"
  
  
end
