class Clasificacion < ActiveRecord::Base
  attr_accessible :categoria, :clase, :descripcion, :division, :grupo, :habilitado
  self.table_name = "empresa_clasificacion"  # El nombre de la tabla que se esta mapeando
end
