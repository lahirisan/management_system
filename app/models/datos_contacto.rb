class DatosContacto < ActiveRecord::Base
  attr_accessible :cargo_contacto, :contacto, :nombre_contacto, :prefijo, :tipo, :datos_contacto
  self.table_name = 'empresa_contacto'
end
