class Correspondencia < ActiveRecord::Base
  attr_accessible :calle, :cargo_rep_tecnico, :cod_postal, :edificio, :id_ciudad, :id_estado, :id_municipio, :id_parroquia, :punto_referencia, :rep_tecnico, :urbanizacion, :nombre_parroquia, :tipo_correspondencia, :correspondencia, :direccion, :piso, :detalle_piso
   self.table_name = "empresa_correspondencia"
   belongs_to :empresa, :foreign_key => "prefijo"
   belongs_to :estado, :foreign_key => "id_estado"
   belongs_to :ciudad, :foreign_key => "id_ciudad"
   belongs_to :municipio, :foreign_key => "id_municipio"
   belongs_to :parroquia, :foreign_key => "id_parroquia"
   #validates :rep_tecnico,   :presence => {:message => "No puede estar en blanco"}, :on => :create

   def self.modificar_etiqueta(parametros)

   	etiqueta = Correspondencia.find(:first, :conditions => ["prefijo = ?", parametros[:empresa_id]])
   	etiqueta.edificio = parametros[:edificio]
   	etiqueta.calle = parametros[:calle]
   	etiqueta.urbanizacion = parametros[:urbanizacion]
   	etiqueta.id_estado = parametros[:id_estado]
   	etiqueta.id_ciudad = parametros[:id_ciudad]
   	etiqueta.id_municipio = parametros[:id_municipio]
   	etiqueta.id_parroquia = parametros[:id_parroquia]
      etiqueta.nombre_parroquia = parametros[:nombre_parroquia]
   	etiqueta.cod_postal = parametros[:cod_postal]
   	etiqueta.punto_referencia = parametros[:punto_referencia]
   	etiqueta.save

   	DatosContacto.modificar_etiqueta(parametros)

   end

  def self.agregar_correspondencia(prefijo, persona_contacto, cargo, edificio, detalle_edificio,piso,  detalle_piso, oficina, detalle_oficina, calle, detalle_calle, urbanizacion, detalle_urbanizacion, estado, ciudad, municipio, parroquia, punto_referencia, codigo_postal, tipo_correspondencia, telefono1, telefono2,telefono3, fax, email)
  
    correspondencia = Correspondencia.new
    correspondencia.prefijo = prefijo
    correspondencia.rep_tecnico = persona_contacto
    correspondencia.cargo_rep_tecnico = cargo
    correspondencia.edificio = edificio
    correspondencia.detalle_edificio = detalle_edificio
    correspondencia.piso = piso
    correspondencia.detalle_piso = detalle_piso
    correspondencia.oficina = oficina
    correspondencia.detalle_oficina = detalle_oficina
    correspondencia.calle = calle
    correspondencia.detalle_calle = detalle_calle
    correspondencia.urbanizacion = urbanizacion
    correspondencia.detalle_urbanizacion = detalle_urbanizacion
    correspondencia.id_estado = estado
    correspondencia.id_ciudad = ciudad
    correspondencia.id_municipio = municipio
    correspondencia.nombre_parroquia = parroquia
    correspondencia.cod_postal = codigo_postal
    correspondencia.punto_referencia = punto_referencia
    correspondencia.tipo_correspondencia = tipo_correspondencia
    correspondencia.telefono1 = telefono1
    correspondencia.telefono2 = telefono2
    correspondencia.telefono3 = telefono3
    correspondencia.fax = fax
    correspondencia.email = email
    correspondencia.save
    raise correspondencia.errors.to_yaml if correspondencia.errors.any?

  end

  def self.modificar_correspondencia(prefijo, persona_contacto, cargo, edificio, detalle_edificio, piso, detalle_piso, oficina, detalle_oficina, calle, detalle_calle, urbanizacion, detalle_urbanizacion, estado, ciudad, municipio, parroquia, punto_referencia, codigo_postal, telefono1, telefono2, telefono3, fax, email, tipo)

   correspondencia = Correspondencia.find(:first, :conditions => ["prefijo = ? and tipo_correspondencia = ?", prefijo, tipo])

   correspondencia.rep_tecnico = persona_contacto
   correspondencia.cargo_rep_tecnico = cargo
   correspondencia.edificio = edificio
   correspondencia.detalle_edificio = detalle_edificio
   correspondencia.piso = piso
   correspondencia.detalle_piso = detalle_piso
   correspondencia.oficina = oficina
   correspondencia.detalle_oficina = detalle_oficina
   correspondencia.calle = calle
   correspondencia.detalle_calle = detalle_calle
   correspondencia.urbanizacion = urbanizacion
   correspondencia.detalle_urbanizacion = detalle_urbanizacion
   correspondencia.id_estado = estado
   correspondencia.id_ciudad = ciudad
   correspondencia.id_municipio = municipio
   correspondencia.cod_postal = codigo_postal
   correspondencia.punto_referencia = punto_referencia
   correspondencia.nombre_parroquia = parroquia
   correspondencia.telefono1 = telefono1
   correspondencia.telefono2 = telefono2
   correspondencia.telefono3 = telefono3
   correspondencia.fax = fax
   correspondencia.email = email
   correspondencia.save

  end
  
end
