class EmpresaRegistrada < ActiveRecord::Base
  
  self.table_name = "empresas_registradas"
  attr_accessible :aporte_mantenimiento, :cargo_rep_legal, :categoria, :cedula_responsable_legal, :circunscripcion_judicial, :clase, :cod_postal_ean, :codigo_postal_edi, :contacto_email1, :contacto_email2, :contacto_fax, :contacto_tlf1, :contacto_tlf2, :contacto_tlf3, :direccion_ean, :direccion_edi,  :direccion_empresa, :direccion_mercadeo,  :direccion_recursos,  :division, :domicilio_responsable_legal, :email1_ean, :email1_edi, :email2_ean, :email_mercadeo, :email_recursos, :fax_ean, :fax_edi, :fax_mercadeo, :fax_recursos, :fecha_inscripcion, :fecha_registro_mercantil, :fecha_ultima_modificacion, :grupo, :id_ciudad, :id_ciudad_ean, :id_ciudad_edi,  :id_clasificacion, :id_estado, :id_estado_ean, :id_estado_edi, :id_estatus, :id_municipio_ean, :id_municipio_edi,  :id_parroquia_ean, :id_parroquia_edi, :id_parroquia_empresa,  :id_tipo_usuario, :nacionalidad_responsable_legal, :nombre_comercial, :nombre_empresa, :numero_registro_mercantil,  :parroquia_ean, :parroquia_edi, :parroquia_empresa, :punto_ref_ean, :punto_ref_edi, :punto_referencia_empresa,  :rep_ean, :rep_ean_cargo, :rep_edi, :rep_edi_cargo, :rep_legal, :rep_mercadeo, :rep_mercadeo_cargo, :rep_recursos, :rep_recursos_cargo, :rif,  :telefono1_ean, :telefono1_edi, :telefono1_mercadeo, :telefono1_recursos, :telefono2_ean, :telefono2_edi,  :telefono3_ean, :telefono3_edi,  :tomo_registro_mercantil, :ventas_brutas_anuales, :id_subestatus, :prefijo, :aporte_mantenimiento_bs

  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :tipo_usuario_empresa, :foreign_key => "id_tipo_usuario"



  validates :id_tipo_usuario, :nombre_empresa, :fecha_inscripcion,  :id_estado, :id_ciudad, :direccion_empresa, :contacto_tlf1, :contacto_email1,  :rif, :id_clasificacion, :rep_legal, :cargo_rep_legal,  :presence => {:message => "No puede estar en blanco"}, :on => :create
  #validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{5,8})-([0-9]{1})$/, on: :create, :message => "El Formato del RIF es invalido"} # Validacion al crear
  validates :rif, :uniqueness => {:message => "La aplicacion detecto que el RIF que esta ingresando ya esta registrado. Por favor verifique."}, :on => :create

  #validates :prefijo, :uniqueness => {:message => "La aplicacion detecto que el RIF que esta ingresando ya esta registrado. Por favor verifique."}, :on => :update
  
end
