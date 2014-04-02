class EmpresaEliminada < ActiveRecord::Base
  attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_status, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif, :id_motivo_retiro, :id_subestatus
  self.table_name = "empresa_eliminada"  # El nombre de la tabla que se esta mapeando
  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"  
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"
  has_one :empresa_elim_detalle,  :foreign_key => "prefijo", :dependent => :destroy # eliminacion en cascada con el detalle de empresa eliminada
end
