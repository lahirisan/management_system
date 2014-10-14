class HistoricoEliminada < ActiveRecord::Base
  attr_accessible :prefijo, :nombre_empresa, :rif, :rep_legal, :contacto_tlf1, :contacto_email1, :fecha_liberacion_prefijo
  self.table_name = "historico_empresas_eliminadas"

  
end
