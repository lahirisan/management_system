class DatosContacto < ActiveRecord::Base
  attr_accessible :cargo_contacto, :contacto, :nombre_contacto, :prefijo, :tipo, :datos_contacto
  self.table_name = 'empresa_contacto'
  validates :contacto, :tipo,  :presence => {:message => "No puede estar en blanco"}, :on => :create
  validates :contacto, format: { with: /^[0-9]\d*$/, on: :create, :message => "Solo numeros para el contacto"} # Validacion al crear

end
