class EmpresaContactoEliminada < ActiveRecord::Base
  self.table_name = "empresa_contacto_eliminada"
  attr_accessible :cargo_contacto, :contacto, :nombre_contacto, :prefijo, :tipo
end
