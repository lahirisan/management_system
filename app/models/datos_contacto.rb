class DatosContacto < ActiveRecord::Base
  attr_accessible :cargo_contacto, :contacto, :nombre_contacto, :prefijo, :tipo, :datos_contacto
  self.table_name = 'empresa_contacto'
  validates :contacto, :tipo, :nombre_contacto, :cargo_contacto,  :presence => {:message => "No puede estar en blanco"}, :on => :create
end
