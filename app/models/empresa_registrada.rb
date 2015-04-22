class EmpresaRegistrada < ActiveRecord::Base
  
  self.table_name = "empresas_registradas"
  attr_accessible :aporte_mantenimiento, :cargo_rep_legal, :categoria, :cedula_responsable_legal, :circunscripcion_judicial, :clase, :cod_postal_ean, :codigo_postal_edi, :contacto_email1, :contacto_email2, :contacto_fax, :contacto_tlf1, :contacto_tlf2, :contacto_tlf3, :direccion_ean, :direccion_edi,  :direccion_empresa, :direccion_mercadeo,  :direccion_recursos,  :division, :domicilio_responsable_legal, :email1_ean, :email1_edi, :email2_ean, :email1_mercadeo, :email1_recursos, :fax_ean, :fax_edi, :fax_mercadeo, :fax_recursos, :fecha_inscripcion, :fecha_registro_mercantil, :fecha_ultima_modificacion, :grupo, :id_ciudad, :id_ciudad_ean, :id_ciudad_edi,  :id_clasificacion, :id_estado, :id_estado_ean, :id_estado_edi, :id_estatus, :id_municipio_ean, :id_municipio_edi,  :id_parroquia_ean, :id_parroquia_edi, :id_parroquia_empresa,  :id_tipo_usuario, :nacionalidad_responsable_legal, :nombre_comercial, :nombre_empresa, :numero_registro_mercantil,  :parroquia_ean, :parroquia_edi, :parroquia_empresa, :punto_ref_ean, :punto_ref_edi, :punto_referencia_empresa,  :rep_ean, :rep_ean_cargo, :rep_edi, :rep_edi_cargo, :rep_legal, :rep_mercadeo, :rep_mercadeo_cargo, :rep_recursos, :rep_recursos_cargo, :rif,  :telefono1_ean, :telefono1_edi, :telefono1_mercadeo, :telefono1_recursos, :telefono2_ean, :telefono2_edi,  :telefono3_ean, :telefono3_edi,  :tomo_registro_mercantil, :ventas_brutas_anuales, :id_subestatus, :prefijo, :aporte_mantenimiento_bs, :tipo_rif, :rif_completo, :tipo_galpon_edificio_quinta, :galpon_edificio_quinta, :tipo_piso_numero, :piso_numero, :tipo_oficina_apartamento, :oficina_apartamento, :tipo_avenida_calle, :avenida_calle, :tipo_urbanizacion_barrio_sector, :urbanizacion_barrio_sector,      :tipo_galpon_edificio_quinta_sincronet, :galpon_edificio_quinta_sincronet, :tipo_piso_numero_sincronet, :piso_numero_sincronet, :tipo_oficina_apartamento_sincronet, :oficina_apartamento_sincronet, :tipo_avenida_calle_sincronet, :avenida_calle_sincronet, :tipo_urbanizacion_barrio_sector_sincronet, :urbanizacion_barrio_sector_sincronet, :email2_edi, :tipo_galpon_edificio_quinta_seminarios, :galpon_edificio_quinta_seminarios, :tipo_piso_numero_seminarios, :piso_numero_seminarios, :tipo_oficina_apartamento_seminarios, :oficina_apartamento_seminarios, :tipo_avenida_calle_seminarios, :avenida_calle_seminarios, :tipo_urbanizacion_barrio_sector_seminarios, :urbanizacion_barrio_sector_seminarios, :email2_recursos,   :tipo_galpon_edificio_quinta_mercadeo, :galpon_edificio_quinta_mercadeo, :tipo_piso_numero_mercadeo, :piso_numero_mercadeo, :tipo_oficina_apartamento_mercadeo, :oficina_apartamento_mercadeo, :tipo_avenida_calle_mercadeo, :avenida_calle_mercadeo, :tipo_urbanizacion_barrio_sector_mercadeo, :urbanizacion_barrio_sector_mercadeo, :email2_mercadeo, :id_estado_mercadeo, :id_ciudad_mercadeo, :id_municipio_mercadeo, :parroquia_mercadeo, :punto_ref_mercadeo, :codigo_postal_mercadeo, :telefono2_mercadeo, :telefono3_mercadeo, :telefono2_recursos, :telefono3_recursos, :id_estado_recursos, :id_ciudad_recursos, :id_municipio_recursos, :parroquia_recursos, :punto_ref_recursos, :codigo_postal_recursos, :cod_contacto_tlf1, :cod_contacto_tlf2, :cod_contacto_tlf3, :cod_contacto_fax, :cod_tlf1_ean, :cod_tlf2_ean, :cod_tlf3_ean, :cod_fax_ean, :cod_tlf1_sincronet, :cod_tlf2_sincronet, :cod_tlf3_sincronet, :cod_fax_sincronet, :cod_tlf1_seminarios,:cod_tlf2_seminarios, :cod_tlf3_seminarios, :cod_fax_seminarios, :cod_tlf1_mercadeo, :cod_tlf2_mercadeo, :cod_tlf3_mercadeo, :cod_fax_mercadeo, :contacto_tlf1_completo, :contacto_tlf2_completo, :contacto_tlf3_completo, :contacto_fax_completo, :telefono1_ean_completo, :telefono2_ean_completo, :telefono3_ean_completo, :fax_ean_completo
  
  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :sub_estatus, :foreign_key => "id_subestatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion"
  belongs_to :tipo_usuario_empresa, :foreign_key => "id_tipo_usuario"

  validates :id_tipo_usuario, :nombre_empresa, :fecha_inscripcion,  :id_estado, :id_ciudad, :direccion_empresa, :cod_contacto_tlf1,:contacto_tlf1,  :contacto_email1,  :rif, :id_clasificacion, :rep_legal, :cargo_rep_legal, :rep_ean, :rep_ean_cargo, :id_estado_ean, :id_ciudad_ean, :id_municipio_ean, :cod_tlf1_ean, :telefono1_ean,   :email1_ean,    :ventas_brutas_anuales, :aporte_mantenimiento_bs, :cod_postal_ean,  :presence => {:message => "No puede estar en blanco"}
  validates :rif, format: { with: /^([0-9]{5,8})-([0-9]{1})$/, :multiline => true,  :message => "Verifique el RIF siga el formato 12345678-9"} # Validacion al crear
  validates :rif_completo, :uniqueness => {:message => "La aplicacion detecto que el RIF que esta ingresando ya esta registrado en el listado de las Nuevas Empresas. Por favor verifique."}, unless: "no_rif_validation == true"
  

  def self.asociar_prefijo(empresa_registrada, fecha_inscripcion)

    empresa = EmpresaRegistrada.new()  
    
    empresa.nombre_empresa = empresa_registrada[:nombre_empresa]
    empresa.fecha_inscripcion = empresa_registrada[:fecha_inscripcion]
    empresa.direccion_empresa = empresa_registrada[:direccion_empresa]
    empresa.id_estado = empresa_registrada[:id_estado]
    empresa.id_ciudad = empresa_registrada[:id_ciudad]
    empresa.rif = empresa_registrada[:rif]
    empresa.tipo_rif = empresa_registrada[:tipo_rif]
    empresa.rif_completo = empresa_registrada[:tipo_rif]+"-"+empresa_registrada[:rif]
    empresa.id_tipo_usuario = empresa_registrada[:id_tipo_usuario]
    empresa.nombre_comercial = empresa_registrada[:nombre_comercial]
    empresa.id_clasificacion = empresa_registrada[:id_clasificacion]
    empresa.categoria = empresa_registrada[:categoria]
    empresa.division = empresa_registrada[:division]
    empresa.grupo = empresa_registrada[:grupo]
    empresa.clase = empresa_registrada[:clase]
    empresa.rep_legal = empresa_registrada[:rep_legal]
    empresa.cargo_rep_legal = empresa_registrada[:cargo_rep_legal]
    empresa.circunscripcion_judicial = empresa_registrada[:circunscripcion_judicial]
    empresa.numero_registro_mercantil = empresa_registrada[:numero_registro_mercantil]
    empresa.tomo_registro_mercantil = empresa_registrada[:tomo_registro_mercantil]
    empresa.nacionalidad_responsable_legal = empresa_registrada[:nacionalidad_responsable_legal]
    empresa.domicilio_responsable_legal = empresa_registrada[:domicilio_responsable_legal]
    empresa.cedula_responsable_legal = empresa_registrada[:cedula_responsable_legal]
    empresa.ventas_brutas_anuales = empresa_registrada[:ventas_brutas_anuales]
    empresa.aporte_mantenimiento_bs = empresa_registrada[:aporte_mantenimiento_bs]
    empresa.fecha_registro_mercantil = empresa_registrada[:fecha_registro_mercantil]
    empresa.parroquia_empresa = empresa_registrada.parroquia_empresa if empresa_registrada[:parroquia_empresa]
    
    empresa.contacto_tlf1 = empresa_registrada[:contacto_tlf1]
    empresa.contacto_tlf2 = empresa_registrada[:contacto_tlf2]
    empresa.contacto_tlf3 = empresa_registrada[:contacto_tlf3]
    empresa.contacto_fax = empresa_registrada[:contacto_fax]

    empresa.cod_contacto_tlf1 = empresa_registrada[:cod_contacto_tlf1]
    empresa.cod_contacto_tlf2 = empresa_registrada[:cod_contacto_tlf2]
    empresa.cod_contacto_tlf3 = empresa_registrada[:cod_contacto_tlf3]
    empresa.cod_contacto_fax = empresa_registrada[:cod_contacto_fax]
    empresa.contacto_email1 = empresa_registrada[:contacto_email1]
    empresa.cod_tlf1_ean = empresa_registrada[:cod_tlf1_ean]
    empresa.cod_tlf2_ean = empresa_registrada[:cod_tlf2_ean]
    empresa.cod_tlf3_ean = empresa_registrada[:cod_tlf3_ean]
    empresa.cod_fax_ean = empresa_registrada[:cod_fax_ean]
    
    empresa.rep_ean = empresa_registrada[:rep_ean]
    empresa.rep_ean_cargo = empresa_registrada[:rep_ean_cargo]
    empresa.punto_ref_ean = empresa_registrada[:punto_ref_ean]
    empresa.id_estado_ean = empresa_registrada[:id_estado_ean]
    empresa.id_ciudad_ean = empresa_registrada[:id_ciudad_ean]
    empresa.id_parroquia_ean = empresa_registrada[:id_parroquia_ean]
    empresa.parroquia_ean = empresa_registrada[:parroquia_ean] if empresa_registrada[:parroquia_ean]
    empresa.cod_postal_ean = empresa_registrada[:cod_postal_ean]
    empresa.telefono1_ean = empresa_registrada[:telefono1_ean]
    empresa.telefono2_ean = empresa_registrada[:telefono2_ean]
    empresa.telefono3_ean = empresa_registrada[:telefono3_ean]
    empresa.fax_ean = empresa_registrada[:fax_ean]
    empresa.email1_ean = empresa_registrada[:email1_ean]
    empresa.id_municipio_ean = empresa_registrada[:id_municipio_ean]
    empresa.direccion_ean = empresa_registrada[:direccion_ean]
    empresa.tipo_galpon_edificio_quinta = empresa_registrada[:tipo_galpon_edificio_quinta]
    empresa.galpon_edificio_quinta = empresa_registrada[:galpon_edificio_quinta]
    empresa.tipo_oficina_apartamento = empresa_registrada[:tipo_oficina_apartamento]
    empresa.oficina_apartamento = empresa_registrada[:oficina_apartamento]
    empresa.tipo_avenida_calle = empresa_registrada[:tipo_avenida_calle]
    empresa.avenida_calle = empresa_registrada[:avenida_calle]
    empresa.tipo_urbanizacion_barrio_sector = empresa_registrada[:tipo_urbanizacion_barrio_sector]
    empresa.urbanizacion_barrio_sector = empresa_registrada[:urbanizacion_barrio_sector]
    empresa.tipo_piso_numero = empresa_registrada[:tipo_piso_numero]
    empresa.piso_numero = empresa_registrada[:piso_numero]
    
    
    empresa.rep_edi = empresa_registrada[:rep_edi]
    empresa.rep_edi_cargo = empresa_registrada[:rep_edi_cargo]
    empresa.id_ciudad_edi = empresa_registrada[:id_ciudad_edi]
    empresa.punto_ref_edi = empresa_registrada[:punto_ref_edi]
    empresa.codigo_postal_edi = empresa_registrada[:codigo_postal_edi]
    empresa.telefono1_edi = empresa_registrada[:telefono1_edi]
    empresa.telefono2_edi = empresa_registrada[:telefono2_edi]
    empresa.telefono3_edi = empresa_registrada[:telefono3_edi]
    empresa.fax_edi = empresa_registrada[:fax_edi]
    empresa.email1_edi = empresa_registrada[:email1_edi]
    
    empresa.id_municipio_edi = empresa_registrada[:id_municipio_edi]
    empresa.id_parroquia_edi = empresa_registrada[:id_parroquia_edi]
    empresa.rep_mercadeo = empresa_registrada[:rep_mercadeo]
    empresa.rep_mercadeo_cargo = empresa_registrada[:rep_mercadeo_cargo]
    empresa.telefono1_mercadeo = empresa_registrada[:telefono1_mercadeo]
    empresa.fax_mercadeo = empresa_registrada[:fax_mercadeo]
    empresa.rep_recursos = empresa_registrada[:rep_recursos]
    empresa.rep_recursos_cargo = empresa_registrada[:rep_recursos_cargo]
    empresa.telefono1_recursos = empresa_registrada[:telefono1_recursos]
    empresa.fax_recursos = empresa_registrada[:fax_recursos]
    
    
    empresa.parroquia_edi = empresa_registrada[:parroquia_edi] if empresa_registrada[:parroquia_edi]
    empresa.id_estado_edi = empresa_registrada[:id_estado_edi]
    
    empresa.direccion_edi = empresa_registrada[:direccion_edi]
    empresa.tipo_galpon_edificio_quinta_sincronet = empresa_registrada[:tipo_galpon_edificio_quinta_sincronet]
    empresa.galpon_edificio_quinta_sincronet = empresa_registrada[:galpon_edificio_quinta_sincronet]
    empresa.tipo_oficina_apartamento_sincronet = empresa_registrada[:tipo_oficina_apartamento_sincronet]
    empresa.oficina_apartamento_sincronet = empresa_registrada[:oficina_apartamento_sincronet]
    empresa.tipo_avenida_calle_sincronet = empresa_registrada[:tipo_avenida_calle_sincronet]
    empresa.avenida_calle_sincronet = empresa_registrada[:avenida_calle_sincronet]
    empresa.tipo_urbanizacion_barrio_sector_sincronet = empresa_registrada[:tipo_urbanizacion_barrio_sector_sincronet]
    empresa.urbanizacion_barrio_sector_sincronet = empresa_registrada[:urbanizacion_barrio_sector_sincronet]
    empresa.tipo_piso_numero_sincronet = empresa_registrada[:tipo_piso_numero_sincronet]
    empresa.piso_numero_sincronet = empresa_registrada[:piso_numero_sincronet]
    
    empresa.email1_recursos = empresa_registrada[:email1_recursos]
    empresa.email1_mercadeo = empresa_registrada[:email1_mercadeo]
    
    empresa.cod_tlf1_sincronet = empresa_registrada[:cod_tlf1_sincronet]
    empresa.cod_tlf2_sincronet = empresa_registrada[:cod_tlf2_sincronet]
    empresa.cod_tlf3_sincronet = empresa_registrada[:cod_tlf3_sincronet]
    empresa.cod_fax_sincronet = empresa_registrada[:cod_fax_sincronet]
    empresa.cod_tlf1_seminarios = empresa_registrada[:cod_tlf1_seminarios]
    empresa.cod_tlf1_mercadeo = empresa_registrada[:cod_tlf1_mercadeo] 
    empresa.fax_ean_completo = empresa_registrada[:fax_ean_completo]
    empresa.telefono3_ean_completo = empresa_registrada[:telefono3_ean_completo]
    empresa.telefono2_ean_completo = empresa_registrada[:telefono2_ean_completo]
    empresa.telefono1_ean_completo = empresa_registrada[:telefono1_ean_completo]
    empresa.contacto_fax_completo = empresa_registrada[:contacto_fax_completo]
    empresa.contacto_tlf3_completo = empresa_registrada[:contacto_tlf3_completo]
    empresa.contacto_tlf2_completo = empresa_registrada[:contacto_tlf2_completo]
    empresa.contacto_tlf1_completo = empresa_registrada[:contacto_tlf1_completo]
    empresa.fecha_inscripcion = fecha_inscripcion
    empresa.id_subestatus = 2 # Se le asigna sub Estatus NO solvente
    empresa.no_rif_validation = true # Esta bandera indica que NO  valide la condicion de RIF unico
    empresa.save!

  end


  
end
