class DatosContacto < ActiveRecord::Base
  attr_accessible :cargo_contacto, :contacto, :nombre_contacto, :prefijo, :tipo, :datos_contacto
  self.table_name = 'empresa_contacto'
  validates :contacto, :tipo,  :presence => {:message => "No puede estar en blanco"}, :on => :create
  #validates :contacto, format: { with: /^[0-9]\d*$/, on: :create, :message => "Solo numeros para el contacto"} # Validacion al crear
  belongs_to :empresa


  def self.modificar_etiqueta(parametros)

  	contacto = DatosContacto.find(:first, :conditions => ["prefijo = ? and tipo = ?", parametros[:empresa_id], 'telefono'])
  	contacto.contacto = parametros[:contacto]
  	contacto.save

    empresa = Empresa.find(:first, :conditions => ["prefijo = ?", parametros[:empresa_id]])
    empresa.rep_legal = parametros[:nombre_contacto]
    empresa.cargo_rep_legal = parametros[:cargo_contacto]
    empresa.save
  end

end
