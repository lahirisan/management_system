class GlnElimDetalle < ActiveRecord::Base
  attr_accessible :fecha_eliminacion, :gln, :id_motivo_retiro, :id_subestatus, :id_usuario
  self.table_name = "gln_elim_detalle"
end
