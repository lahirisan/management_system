class Empresa < ActiveRecord::Base
  self.table_name = "empresa"  # El nombre de la tabla que se esta mapeando
  has_one :correspondencia, :foreign_key => "prefijo"
  accepts_nested_attributes_for :correspondencia, :allow_destroy => true # Maneja el modelo correspondencia en el formulario de empresa
  attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_estatus, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif, :prefijo,  :correspondencia_attributes # Los atributos de correspondecia
  
  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"  
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion" 
  
  validates :nombre_empresa, :fecha_inscripcion, :direccion_empresa, :id_estado, :id_ciudad, :rif, :prefijo,   :presence => {:message => "No puede estar en blanco"}
  validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{8})-([0-9]{1})$/, on: :create, :message => "El Formato del RIF es invalido"} # Validacion al crear
  validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{8})-([0-9]{1})$/, on: :update, :message => "El Formato del RIF es invalido"} # Validacion al editar


  def self.to_csv # Se genera el CSV de Empresas

  	CSV.generate do |csv|
  		all.each do |empresa|
  			csv << empresa.attributes.values_at(*column_names)
  		end
    end 
  end 
end
