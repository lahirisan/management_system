	#encoding: UTF-8
	class Empresa < ActiveRecord::Base
	self.table_name = "empresa"  # El nombre de la tabla que se esta mapeando
	self.primary_key = "prefijo" # Se establece la clave primaria
	
	
	attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_estatus, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif, :prefijo,  :numero_registro_mercantil, :tomo_registro_mercantil, :nit_registro_mercantil, :nacionalidad_responsable_legal, :domicilio_responsable_legal, :cedula_responsable_legal, :circunscripcion_judicial, :ventas_brutas_anuales, :fecha_registro_mercantil, :contacto_tlf1, :contacto_tlf2, :contacto_tlf3, :contacto_fax, :contacto_email1, :contacto_email2, :rep_ean, :rep_ean_cargo, :direccion_ean1, :direccion_ean3, :direccion_ean4, :id_estado_ean, :id_ciudad_ean, :id_municipio_ean, :parroquia_ean, :punto_ref_ean, :cod_postal_ean, :telefono1_ean, :telefono2_ean, :telefono3_ean, :fax_ean, :email1_ean, :email2_ean, :rep_edi, :rep_edi_cargo, :direccion_edi1, :direccion_edi2, :direccion_edi3, :id_estado_edi, :id_ciudad_edi, :id_municipio_edi, :parroquia_edi, :punto_ref_edi, :codigo_postal_edi, :telefono1_edi, :telefono2_edi, :telefono3_edi, :fax_edi, :email1_edi, :rep_recursos, :rep_recursos_cargo, :telefono1_recursos, :fax_recursos, :email_recursos, :rep_mercadeo, :rep_mercadeo_cargo, :telefono1_mercadeo, :fax_mercadeo,  :direccion_ean, :direccion_edi, :direccion_recursos, :direccion_mercadeo, :fecha_activacion, :id_subestatus, :administrativo, :aporte_mantenimiento_bs, :tipo_rif, :rif_completo, :tipo_galpon_edificio_quinta, :galpon_edificio_quinta, :tipo_oficina_apartamento, :oficina_apartamento, :tipo_avenida_calle, :avenida_calle, :tipo_urbanizacion_barrio_sector, :urbanizacion_barrio_sector, :tipo_piso_numero, :piso_numero, :tipo_galpon_edificio_quinta_sincronet, :galpon_edificio_quinta_sincronet, :tipo_oficina_apartamento_sincronet, :oficina_apartamento_sincronet, :tipo_avenida_calle_sincronet, :avenida_calle_sincronet, :tipo_urbanizacion_barrio_sector_sincronet, :urbanizacion_barrio_sector_sincronet, :tipo_piso_numero_sincronet, :piso_numero_sincronet, :tipo_galpon_edificio_quinta_seminarios, :galpon_edificio_quinta_seminarios, :tipo_oficina_apartamento_seminarios, :oficina_apartamento_seminarios, :tipo_avenida_calle_seminarios, :avenida_calle_seminarios, :tipo_urbanizacion_barrio_sector_seminarios, :urbanizacion_barrio_sector_seminarios, :tipo_piso_numero_seminarios, :piso_numero_seminarios, :tipo_galpon_edificio_quinta_mercadeo, :galpon_edificio_quinta_mercadeo, :tipo_oficina_apartamento_mercadeo, :oficina_apartamento_mercadeo, :tipo_avenida_calle_mercadeo, :avenida_calle_mercadeo, :tipo_urbanizacion_barrio_sector_mercadeo, :urbanizacion_barrio_sector_mercadeo, :tipo_piso_numero_mercadeo, :piso_numero_mercadeo, :id_estado_mercadeo, :parroquia_mercadeo, :punto_ref_mercadeo, :telefono3_mercadeo, :email2_edi, :email2_recursos, :email2_mercadeo, :email1_recursos, :email1_mercadeo, :telefono3_recursos, :id_estado_recursos, :punto_ref_recursos, :cod_contacto_tlf1, :cod_contacto_tlf3, :cod_contacto_fax, :cod_tlf1_ean, :cod_tlf2_ean, :cod_tlf3_ean, :cod_fax_ean, :cod_tlf1_sincronet, :cod_tlf2_sincronet, :cod_tlf3_sincronet, :cod_fax_sincronet, :cod_tlf1_seminarios, :cod_tlf2_seminarios, :cod_tlf3_seminarios, :cod_fax_seminarios, :cod_tlf1_mercadeo, :cod_tlf2_mercadeo, :cod_tlf3_mercadeo, :cod_fax_mercadeo, :contacto_tlf1_completo, :contacto_tlf2_completo, :contacto_tlf3_completo, :contacto_fax_completo, :telefono1_ean_completo, :telefono2_ean_completo, :telefono3_ean_completo, :fax_ean_completo, :id_ciudad_recursos, :id_municipio_recursos, :parroquia_recursos, :codigo_postal_recursos, :telefono2_recursos, :cod_contacto_tlf2, :codigo_postal_mercadeo, :telefono2_mercadeo, :id_municipio_mercadeo, :id_ciudad_mercadeo, :fecha_reactivacion, :no_rif_validation  
	belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
	belongs_to :ciudad, :foreign_key =>  "id_ciudad"
	belongs_to :municipio, :foreign_key => "id_municipio"
	belongs_to :estatus, :foreign_key =>  "id_estatus"
	belongs_to :clasificacion, :foreign_key => "id_clasificacion"
	belongs_to :sub_estatus, :foreign_key => "id_subestatus"
	belongs_to :tipo_usuario, :foreign_key => "id_tipo_usuario"
	belongs_to :motivo_retiro, :foreign_key => "id_motivo_retiro"

	has_many :producto, :foreign_key => "prefijo", :dependent => :destroy# Define una asociaicion 1 a N con productos_empresa
	has_many :empresa_servicio, :foreign_key => "prefijo", :dependent => :destroy
	
	# Asi es como se debe hacer con las asociaciones con tablas de por medio, para manejar correctamente los helper de los formularios
	has_many :gln, :foreign_key => "prefijo" , :dependent => :destroy# Define una asociaicion 1 a N con productos_empresa
	
	belongs_to :tipo_usuario_empresa, :foreign_key => "id_tipo_usuario"
	
	validates :tipo_rif, :rif,  :id_tipo_usuario, :id_clasificacion, :presence => {:message => "No puede estar en blanco"}

	validates :rif_completo, :uniqueness => {:message => "La aplicacion detecto que el RIF que esta ingresando ya esta registrado en el listado de las Empresas. Por favor verifique."}, on: :create, unless: "no_rif_validation == true"

	
 
	def self.cambiar_sub_estatus(parametros)
		
		parametros[:sub_estatus_empresas].collect{|empresa_seleccionada|  empresa = Empresa.find(empresa_seleccionada); empresa.id_subestatus = parametros[:"#{empresa.prefijo}"].to_i; empresa.save}

	end

	def self.retirar_empresas(prefijo, motivo_retiro)
		
		Empresa.find_by(prefijo: prefijo).update_columns(:id_estatus => 2, :fecha_retiro => Time.now, :id_motivo_retiro => motivo_retiro)
		
		# Se retiran sus productos
		Producto.where("prefijo = #{prefijo}").update_all("id_estatus = 4" )

		# Se retiran sus GLN
		Gln.where("prefijo = #{prefijo}").update_all("id_estatus = 12" )
			
	end

	def self.eliminar_empresas(parametros)
		
		# OJO: Esto se peude optimizar actualizando masivamente // RailsCast 198
		
			for eliminar_empresas in (0..parametros[:eliminar_empresas].size-1)
				empresa_seleccionada = parametros[:eliminar_empresas][eliminar_empresas]
				
				empresa_eliminar = Empresa.find(empresa_seleccionada)
				
				empresa_eliminada = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", empresa_eliminar.prefijo])

				empresa_eliminada.destroy if empresa_eliminada
				Empresa.registrar_eliminada(empresa_eliminar)
				empresa_eliminar.destroy # Se elimina la retirada
				
			end
	end
	

	def self.reactivar_empresas_retiradas(parametros)

		
		empresas = Empresa.find(parametros[:reactivar_empresas])
		
		empresas.each{|empresa| 
			empresa.id_estatus = 1;  # Estatus empresa activa segun tabla ESTATUS
			empresa.fecha_reactivacion = Time.now; 
			empresa.save;
			Producto.where("prefijo = #{empresa.prefijo}").update_all("id_estatus = 3" ); # ESTATUS PRODUCTO ACTIVO SEGUN TABLA
			Gln.where("prefijo = #{empresa.prefijo}").update_all("id_estatus = 9" ) # Estatus GLN ACTIVO
		}

		
		
		 
	end


	

	def self.generar_prefijo_valido

		# Falta validar el caso en que no hay PREFIJOS disponibles 759XXXX
		
		empresa = Empresa.find(:first, :conditions => ["prefijo >= 7590000 and prefijo <= 7599999 and prefijo != 7599000 "], :order => "prefijo DESC")
		prefijo = empresa.prefijo + 1
		prefijo = prefijo + 1 if prefijo == 7599000 # PREFIJO de GS1
		prefijo = busqueda_exhaustiva_prefijo if (prefijo > 7599999) ## Probar en su momento

		return prefijo

	end
	
	def self.busqueda_exhaustiva_prefijo

		
		
		#prefijos_asignados = Empresa.find(:all, :conditions => ["prefijo >= 7599000 and prefijo <= 75999999"], :select => "prefijo")
		#prefijos_disponible = Empresa.find(:first, :conditions => ["prefijo >= ? and prefijo <= ? and prefijo not in (?)", 7599000, 7599999, prefijos_asignados.collect{|empresa| empresa.prefijo}], :order => "empresa.prefijo asc")

		prefijos_disponibles = Empresa.where(["prefijo < 7599000"]).select("prefijo").last
		return (prefijos_disponibles.prefijo + 1)

	end

 

	def self.registrar_historico_eliminada(eliminada)

		

				historico_eliminada = HistoricoEliminada.new
			 historico_eliminada.prefijo = eliminada.prefijo
			 historico_eliminada.nombre_empresa = eliminada.nombre_empresa
			 historico_eliminada.rif = eliminada.rif
			 historico_eliminada.rep_legal = eliminada.rep_legal
			 historico_eliminada.contacto_tlf1 = eliminada.contacto_tlf1
			 historico_eliminada.contacto_email1 = eliminada.contacto_email1
			 historico_eliminada.fecha_liberacion_prefijo = Time.now
			 historico_eliminada.save
			 eliminada.destroy

	end


	def self.registrar_eliminada(empresa)


		estatus_empresa = Estatus.find(:first, :conditions => ["descripcion like ? and alcance = ? ", "Eliminada", 'Empresa'])
				

		empresa_eliminada =  EmpresaEliminada.new  # Se crear el registro de la empresa_eliminada
		empresa_eliminada.prefijo = empresa.prefijo
		empresa_eliminada.nombre_empresa = empresa.nombre_empresa

		empresa_eliminada.rif = empresa.rif.strip

		empresa_eliminada.categoria = empresa.try(:categoria)
		empresa_eliminada.division = empresa.try(:division)
		empresa_eliminada.grupo = empresa.try(:grupo)
		empresa_eliminada.clase = empresa.try(:clase)
		empresa_eliminada.rep_legal = empresa.try(:rep_legal)
		empresa_eliminada.contacto_tlf1 = empresa.try(:contacto_tlf1)
		empresa_eliminada.contacto_email1 = empresa.try(:contacto_email1)
		empresa_eliminada.id_motivo_retiro = empresa.try(:id_motivo_retiro)
		empresa_eliminada.id_tipo_usuario_empresa = empresa.try(:id_tipo_usuario)
		empresa_eliminada.fecha_retiro = empresa.try(:fecha_retiro)
		empresa_eliminada.fecha_eliminacion = Time.now
		empresa_eliminada.id_estatus = estatus_empresa.id
		empresa_eliminada.save


 end


 def self.sincronizar_solventes_desde_excel ## Procedimiento para sincronizar el estatus de las empresas  SOLVENTES

	spreadsheet = Roo::Excelx.new("#{Rails.root}/doc/SOLVENTES.xlsx", nil, :ignore)

		(2..spreadsheet.last_row).each do |fila|

			 empresa_solvente = Empresa.find(spreadsheet.cell(fila,1))
		 
			 raise "No se encontro el prefijo #{spreadsheet.cell(fila,1)}".to_yaml if empresa_solvente.nil?
			 empresa_solvente.id_subestatus = 1
			 empresa_solvente.save
		 

		end


 end


 def self.sincronizar_aporte_mantenimiento ## Procedimiento para sincronizar el estatus de las empresas  SOLVENTES

	spreadsheet = Roo::Excelx.new("#{Rails.root}/doc/aporte_mantenimiento.xlsx", nil, :ignore)

		(1..spreadsheet.last_row).each do |fila|

			 empresa = Empresa.find(spreadsheet.cell(fila,1))
		 
				if empresa
					empresa.aporte_mantenimiento = (spreadsheet.cell(fila,2))
					empresa.save
				end
		 

		end


 end


 def self.activar(empresa_registrada, prefijo)

	empresa = Empresa.new
	empresa.prefijo = prefijo
	empresa.nombre_empresa = empresa_registrada.nombre_empresa
	empresa.fecha_inscripcion = Time.now
	empresa.direccion_empresa = empresa_registrada.direccion_empresa
	empresa.id_estado = empresa_registrada.id_estado
	empresa.id_ciudad = empresa_registrada.id_ciudad
	empresa.rif = empresa_registrada.rif
	empresa.tipo_rif = empresa_registrada.tipo_rif
	empresa.rif_completo = empresa_registrada.rif_completo
	empresa.id_estatus = 1 # empresas activa
	empresa.id_tipo_usuario = empresa_registrada.id_tipo_usuario
	empresa.nombre_comercial = (empresa_registrada.nombre_comercial) ? empresa_registrada.nombre_comercial :  ""
	empresa.id_clasificacion = empresa_registrada.id_clasificacion
	empresa.categoria = empresa_registrada.categoria
	empresa.division = empresa_registrada.division
	empresa.grupo = empresa_registrada.grupo
	empresa.clase = empresa_registrada.clase

	empresa.rep_legal = empresa_registrada.rep_legal
	empresa.cargo_rep_legal = empresa_registrada.cargo_rep_legal

	empresa.circunscripcion_judicial = empresa_registrada.circunscripcion_judicial
	empresa.numero_registro_mercantil = (empresa_registrada.numero_registro_mercantil) ? empresa_registrada.numero_registro_mercantil : ""
	empresa.tomo_registro_mercantil = (empresa_registrada.tomo_registro_mercantil) ?  empresa_registrada.tomo_registro_mercantil : ""
	empresa.nacionalidad_responsable_legal = (empresa_registrada.nacionalidad_responsable_legal) ? empresa_registrada.nacionalidad_responsable_legal : ""
	empresa.domicilio_responsable_legal = (empresa_registrada.domicilio_responsable_legal) ? empresa_registrada.domicilio_responsable_legal : ""
	empresa.cedula_responsable_legal = (empresa_registrada.cedula_responsable_legal) ? empresa_registrada.cedula_responsable_legal : ""
	empresa.ventas_brutas_anuales = empresa_registrada.ventas_brutas_anuales
	empresa.aporte_mantenimiento_bs = empresa_registrada.aporte_mantenimiento_bs
	empresa.fecha_registro_mercantil = (empresa_registrada.fecha_registro_mercantil) ? empresa_registrada.fecha_registro_mercantil : ""
	empresa.id_parroquia_empresa = empresa_registrada.id_parroquia_empresa
	empresa.parroquia_empresa = (empresa_registrada.parroquia_empresa) ? empresa_registrada.parroquia_empresa  : ""
	
	empresa.cod_contacto_tlf1 = empresa_registrada.cod_contacto_tlf1
	empresa.cod_contacto_tlf2 = empresa_registrada.cod_contacto_tlf2
	empresa.cod_contacto_tlf3 = empresa_registrada.cod_contacto_tlf3
	empresa.cod_contacto_fax = empresa_registrada.cod_contacto_fax
	
	empresa.contacto_tlf1 = empresa_registrada.contacto_tlf1
	empresa.contacto_tlf2 = empresa_registrada.contacto_tlf2
	empresa.contacto_tlf3 = empresa_registrada.contacto_tlf3	
	empresa.contacto_fax = empresa_registrada.contacto_fax
	empresa.contacto_email1 = empresa_registrada.contacto_email1


	
	empresa.fecha_ultima_modificacion = (empresa_registrada.fecha_ultima_modificacion) ?  empresa_registrada.fecha_ultima_modificacion : ""

	empresa.contacto_tlf1_completo = empresa_registrada.cod_contacto_tlf1 + " " + empresa_registrada.contacto_tlf1
	empresa.contacto_tlf2_completo = empresa_registrada.cod_contacto_tlf2 +  " " + empresa_registrada.contacto_tlf2
	empresa.contacto_tlf3_completo = empresa_registrada.cod_contacto_tlf3 + " " + empresa_registrada.contacto_tlf3
	empresa.contacto_fax_completo = empresa_registrada.cod_contacto_fax + " " + empresa_registrada.contacto_fax
	
	# DATOS EAN

	empresa.rep_ean = empresa_registrada.rep_ean
	empresa.rep_ean_cargo = empresa_registrada.rep_ean_cargo
	empresa.punto_ref_ean = empresa_registrada.punto_ref_ean
	empresa.id_estado_ean = empresa_registrada.id_estado_ean
	empresa.id_ciudad_ean = empresa_registrada.id_ciudad_ean
	empresa.id_municipio_ean = empresa_registrada.id_municipio_ean
	empresa.id_parroquia_ean = empresa_registrada.id_parroquia_ean

	empresa.tipo_galpon_edificio_quinta = empresa_registrada.tipo_galpon_edificio_quinta
	empresa.galpon_edificio_quinta = empresa_registrada.galpon_edificio_quinta
	empresa.tipo_oficina_apartamento = empresa_registrada.tipo_oficina_apartamento
	empresa.oficina_apartamento = empresa_registrada.oficina_apartamento
	empresa.tipo_avenida_calle = empresa_registrada.tipo_avenida_calle
	empresa.avenida_calle = empresa_registrada.avenida_calle
	empresa.tipo_urbanizacion_barrio_sector = empresa_registrada.tipo_urbanizacion_barrio_sector
	empresa.urbanizacion_barrio_sector = empresa_registrada.urbanizacion_barrio_sector
	empresa.tipo_piso_numero = empresa_registrada.tipo_piso_numero
	empresa.piso_numero = empresa_registrada.piso_numero
	

	empresa.parroquia_ean = (empresa_registrada.parroquia_ean) ? empresa_registrada.parroquia_ean : ""
	empresa.cod_postal_ean = empresa_registrada.cod_postal_ean
	empresa.direccion_ean = empresa_registrada.direccion_ean

	empresa.cod_tlf1_ean = empresa_registrada.cod_tlf1_ean
	empresa.cod_tlf2_ean = empresa_registrada.cod_tlf2_ean
	empresa.cod_tlf3_ean = empresa_registrada.cod_tlf3_ean
	empresa.cod_fax_ean = empresa_registrada.cod_fax_ean
	
	empresa.telefono1_ean = empresa_registrada.telefono1_ean
	empresa.telefono2_ean = empresa_registrada.telefono2_ean
	empresa.telefono3_ean = empresa_registrada.telefono3_ean
	empresa.fax_ean = empresa_registrada.fax_ean

	empresa.email1_ean = empresa_registrada.email1_ean
	empresa.email2_ean = empresa_registrada.email1_ean # Este campo se elimina de la planilla, por lo que se manda el email1_ean  ya que es requerido en el administrativo

	empresa.fax_ean_completo = empresa_registrada.cod_fax_ean + " " + empresa_registrada.fax_ean
	empresa.telefono3_ean_completo = empresa_registrada.cod_tlf3_ean + " " + empresa_registrada.telefono3_ean
	empresa.telefono2_ean_completo = empresa_registrada.cod_tlf2_ean + " " + empresa_registrada.telefono2_ean
	empresa.telefono1_ean_completo = empresa_registrada.cod_tlf1_ean  + " " + empresa_registrada.telefono1_ean

	

	# DATOS EDI

	empresa.rep_edi = empresa_registrada.rep_edi
	empresa.rep_edi_cargo = empresa_registrada.rep_edi_cargo
	
	empresa.parroquia_edi = empresa_registrada.parroquia_edi
	empresa.id_estado_edi = empresa_registrada.id_estado_edi
	empresa.id_ciudad_edi = empresa_registrada.id_ciudad_edi
	
	empresa.email1_edi = empresa_registrada.email1_edi

	
	empresa.id_municipio_edi = empresa_registrada.id_municipio_edi
	empresa.id_parroquia_edi = empresa_registrada.id_parroquia_edi
	empresa.tipo_galpon_edificio_quinta_sincronet = empresa_registrada.tipo_galpon_edificio_quinta_sincronet
	empresa.galpon_edificio_quinta_sincronet = empresa_registrada.galpon_edificio_quinta_sincronet
	empresa.tipo_oficina_apartamento_sincronet = empresa_registrada.tipo_oficina_apartamento_sincronet
	empresa.oficina_apartamento_sincronet = empresa_registrada.oficina_apartamento_sincronet
	empresa.tipo_avenida_calle_sincronet = empresa_registrada.tipo_avenida_calle_sincronet
	empresa.avenida_calle_sincronet = empresa_registrada.avenida_calle_sincronet
	empresa.tipo_urbanizacion_barrio_sector_sincronet = empresa_registrada.tipo_urbanizacion_barrio_sector_sincronet
	empresa.urbanizacion_barrio_sector_sincronet = empresa_registrada.urbanizacion_barrio_sector_sincronet
	empresa.tipo_piso_numero_sincronet = empresa_registrada.tipo_piso_numero_sincronet
	empresa.piso_numero_sincronet = empresa_registrada.piso_numero_sincronet
	
	empresa.direccion_edi = empresa_registrada.direccion_edi


	empresa.cod_tlf1_sincronet = empresa_registrada.cod_tlf1_sincronet
	empresa.cod_tlf2_sincronet = empresa_registrada.cod_tlf2_sincronet
	empresa.cod_tlf3_sincronet = empresa_registrada.cod_tlf3_sincronet
	empresa.cod_fax_sincronet = empresa_registrada.cod_fax_sincronet
	
	empresa.telefono1_edi = empresa_registrada.telefono1_edi
	empresa.telefono2_edi = empresa_registrada.telefono2_edi
	empresa.telefono3_edi = empresa_registrada.telefono3_edi
	empresa.fax_edi = empresa_registrada.fax_edi
	empresa.punto_ref_edi = empresa_registrada.punto_ref_edi
	empresa.codigo_postal_edi = empresa_registrada.codigo_postal_edi
	


	# Datos MERCADEO
	
	empresa.rep_mercadeo = empresa_registrada.rep_mercadeo
	empresa.rep_mercadeo_cargo = empresa_registrada.rep_mercadeo_cargo
	
	empresa.cod_tlf1_mercadeo = empresa_registrada.cod_tlf1_mercadeo
	empresa.cod_fax_mercadeo = empresa_registrada.cod_fax_mercadeo
	empresa.telefono1_mercadeo = empresa_registrada.telefono1_mercadeo
	empresa.fax_mercadeo = empresa_registrada.fax_mercadeo
	empresa.email1_mercadeo = empresa_registrada.email1_mercadeo

	# DATOS RRHH


	empresa.rep_recursos = empresa_registrada.rep_recursos
	empresa.rep_recursos_cargo = empresa_registrada.rep_recursos_cargo

	empresa.cod_tlf1_seminarios = empresa_registrada.cod_tlf1_seminarios
	empresa.cod_fax_seminarios = empresa_registrada.cod_fax_seminarios
	empresa.telefono1_recursos = empresa_registrada.telefono1_recursos
	empresa.fax_recursos = empresa_registrada.fax_recursos
	empresa.email1_recursos = empresa_registrada.email1_recursos

	
	
	empresa.id_subestatus = empresa_registrada.id_subestatus
	empresa.fecha_activacion = Time.now

	

	empresa.no_rif_validation = true if empresa_registrada.no_rif_validation == true
	empresa.save
	empresa_registrada.destroy
	
	eliminada = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", empresa.prefijo])
	Empresa.registrar_historico_eliminada(eliminada) if eliminada # Se esta utilizando un prefijo de empresa eliminada
	
	Gln.generar_legal(empresa.prefijo.to_s) if empresa.id_tipo_usuario == '1' # SOlo LAs empresas de Tipo Usuario registran GLN

 end

 def self.telefono1(empresa)

		
		telefono1 = empresa.cod_contacto_tlf1 + "-" + empresa.contacto_tlf1 if (empresa.cod_contacto_tlf1) and (empresa.contacto_tlf1)
		telefono1 = empresa.contacto_tlf1 if empresa.cod_contacto_tlf1.nil? and empresa.contacto_tlf1

		return telefono1

 end

 def self.telefono2(empresa)

		telefono2 = empresa.cod_contacto_tlf2 + "-" + empresa.contacto_tlf2 if (empresa.cod_contacto_tlf2) and (empresa.contacto_tlf2)
		telefono2 = empresa.contacto_tlf2 if empresa.cod_contacto_tlf2.nil? and (empresa.contacto_tlf2)
		
		return telefono2

 end

 def self.telefono3(empresa)

		telefono3 = empresa.cod_contacto_tlf3 + "-" + empresa.contacto_tlf3 if (empresa.cod_contacto_tlf3) and (empresa.contacto_tlf3)
		telefono3 = empresa.contacto_tlf3 if empresa.cod_contacto_tlf3.nil? and (empresa.contacto_tlf3)
		
		return telefono3

 end

 def self.fax(empresa)

		fax = empresa.cod_contacto_fax + "-" + empresa.contacto_fax if (empresa.cod_contacto_fax) and (empresa.contacto_fax)
		fax = empresa.contacto_fax if empresa.cod_contacto_fax.nil? and (empresa.contacto_fax)
		
		return fax

 end

 def self.correo1(empresa)
	correo1 = empresa.contacto_email1 
	return correo1

 end 

 def self.correo2(empresa)
	correo2 = empresa.contacto_email2 
	return correo2

 end

 def self.telefono1_ean(empresa)
	
	telefono1_ean = "("+empresa.cod_tlf1_ean + ") " +empresa.telefono1_ean if (empresa.cod_tlf1_ean) and (empresa.telefono1_ean)
	telefono1_ean = empresa.telefono1_ean if (empresa.cod_tlf1_ean).nil?
	telefono1_ean = "" if (empresa.cod_tlf1_ean.nil?) and (empresa.telefono1_ean.nil?)
	return telefono1_ean

 end

 def self.telefono2_ean(empresa)
	
	telefono2_ean = "("+empresa.cod_tlf2_ean + ") " +empresa.telefono2_ean if (empresa.cod_tlf2_ean) and (empresa.telefono2_ean)
	telefono2_ean = empresa.telefono2_ean if (empresa.cod_tlf2_ean).nil?
	telefono2_ean = "" if (empresa.cod_tlf2_ean.nil?) and (empresa.telefono2_ean.nil?)
	return telefono2_ean

 end

 def self.telefono3_ean(empresa)
	
	telefono3_ean = "("+empresa.cod_tlf3_ean + ") " +empresa.telefono3_ean if (empresa.cod_tlf3_ean) and (empresa.telefono3_ean)
	telefono3_ean = empresa.telefono3_ean if (empresa.cod_tlf3_ean).nil?
	telefono3_ean = "" if (empresa.cod_tlf3_ean.nil?) and (empresa.telefono3_ean.nil?)
	return telefono3_ean

 end

 def self.fax_ean(empresa)
	
	fax_ean = "("+empresa.cod_fax_ean + ") " +empresa.fax_ean if (empresa.cod_fax_ean) and (empresa.fax_ean)
	fax_ean = empresa.fax_ean if (empresa.cod_fax_ean).nil?
	fax_ean = "" if (empresa.cod_fax_ean.nil?) and (empresa.fax_ean.nil?)
	return fax_ean

 end

 
 def self.telefono1_edi(empresa)
	
	telefono1_edi = "("+empresa.cod_tlf1_sincronet + ") " +empresa.telefono1_edi if (empresa.cod_tlf1_sincronet) and (empresa.telefono1_edi)
	telefono1_edi = empresa.telefono1_edi if (empresa.cod_tlf1_sincronet).nil?
	telefono1_edi = "" if (empresa.cod_tlf1_sincronet.nil?) and (empresa.telefono1_edi.nil?)
	return telefono1_edi

 end

 def self.telefono2_edi(empresa)
	
	telefono2_edi = "("+empresa.cod_tlf2_sincronet + ") " +empresa.telefono2_edi if (empresa.cod_tlf2_sincronet) and (empresa.telefono2_edi)
	telefono2_edi = empresa.telefono2_edi if (empresa.cod_tlf2_sincronet).nil?
	telefono2_edi = "" if (empresa.cod_tlf2_sincronet.nil?) and (empresa.telefono2_edi.nil?)
	return telefono2_edi

 end

 def self.telefono3_edi(empresa)
	
	telefono3_edi = "("+empresa.cod_tlf3_sincronet + ") " +empresa.telefono3_edi if (empresa.cod_tlf3_sincronet) and (empresa.telefono3_edi)

	telefono3_edi = empresa.telefono3_edi if (empresa.cod_tlf3_sincronet).nil?
	telefono3_edi = "" if (empresa.cod_tlf3_sincronet.nil?) and (empresa.telefono3_edi.nil?)
	return telefono3_edi

 end

 def self.fax_edi(empresa)
	
	fax_edi = "("+empresa.cod_fax_sincronet + ") " +empresa.fax_edi if (empresa.cod_fax_sincronet) and (empresa.fax_edi)
	fax_edi = empresa.fax_edi if (empresa.cod_fax_sincronet).nil?
	fax_edi = "" if (empresa.cod_fax_sincronet.nil?) and (empresa.fax_edi.nil?)
	return fax_edi

 end

 def self.telefono1_recursos(empresa)
	
	telefono1_recursos = "("+empresa.cod_tlf1_seminarios + ") " +empresa.telefono1_recursos if (empresa.cod_tlf1_seminarios) and (empresa.telefono1_recursos)
	telefono1_recursos = empresa.telefono1_recursos if (empresa.cod_tlf1_seminarios).nil?
	telefono1_recursos = "" if (empresa.cod_tlf1_seminarios.nil?) and (empresa.telefono1_recursos.nil?)
	return telefono1_recursos

 end

 def self.telefono2_recursos(empresa)
	
	telefono2_recursos = "("+empresa.cod_tlf2_seminarios + ") " +empresa.telefono2_recursos if (empresa.cod_tlf2_seminarios) and (empresa.telefono2_recursos)
	telefono2_recursos = empresa.telefono2_recursos if (empresa.cod_tlf2_seminarios).nil?
	telefono2_recursos = "" if (empresa.cod_tlf2_seminarios.nil?) and (empresa.telefono2_recursos.nil?)
	return telefono2_recursos

 end

 def self.telefono3_recursos(empresa)
	
	telefono3_recursos = "("+empresa.cod_tlf3_seminarios + ") " +empresa.telefono3_recursos if (empresa.cod_tlf3_seminarios) and (empresa.telefono3_recursos)
	telefono3_recursos = empresa.telefono3_recursos if (empresa.cod_tlf3_seminarios).nil?
	telefono3_recursos = "" if (empresa.cod_tlf3_seminarios.nil?) and (empresa.telefono3_recursos.nil?)
	return telefono3_recursos

 end

 def self.fax_recursos(empresa)
	
	fax_recursos = "("+empresa.cod_fax_seminarios + ") " +empresa.fax_recursos if (empresa.cod_fax_seminarios) and (empresa.fax_recursos)
	fax_recursos = empresa.fax_recursos if (empresa.cod_fax_seminarios).nil?
	fax_recursos = "" if (empresa.cod_fax_seminarios.nil?) and (empresa.fax_recursos.nil?)
	return fax_recursos

 end


 def self.telefono1_mercadeo(empresa)
	
	telefono1_mercadeo = "("+empresa.cod_tlf1_mercadeo + ") " +empresa.telefono1_mercadeo if (empresa.cod_tlf1_mercadeo) and (empresa.telefono1_mercadeo)
	telefono1_mercadeo = empresa.telefono1_mercadeo if (empresa.cod_tlf1_mercadeo).nil?
	telefono1_mercadeo = "" if (empresa.cod_tlf1_mercadeo.nil?) and (empresa.telefono1_mercadeo.nil?)
	return telefono1_mercadeo

 end

 def self.telefono2_mercadeo(empresa)
	
	telefono2_mercadeo = "("+empresa.cod_tlf2_mercadeo + ") " +empresa.telefono2_mercadeo if (empresa.cod_tlf2_mercadeo) and (empresa.telefono2_mercadeo)
	telefono2_mercadeo = empresa.telefono2_mercadeo if (empresa.cod_tlf2_mercadeo).nil?
	telefono2_mercadeo = "" if (empresa.cod_tlf2_mercadeo.nil?) and (empresa.telefono2_mercadeo.nil?)
	return telefono2_mercadeo

 end

 def self.telefono3_mercadeo(empresa)
	
	telefono3_mercadeo = "("+empresa.cod_tlf3_mercadeo + ") " +empresa.telefono3_mercadeo if (empresa.cod_tlf3_mercadeo) and (empresa.telefono3_mercadeo)
	telefono3_mercadeo = empresa.telefono3_mercadeo if (empresa.cod_tlf3_mercadeo).nil?
	telefono3_mercadeo = "" if (empresa.cod_tlf3_mercadeo.nil?) and (empresa.telefono3_mercadeo.nil?)
	return telefono3_mercadeo

 end

 def self.fax_mercadeo(empresa)
	
	fax_mercadeo = "("+empresa.cod_fax_mercadeo + ") " +empresa.fax_mercadeo if (empresa.cod_fax_mercadeo) and (empresa.fax_mercadeo)
	fax_mercadeo = empresa.fax_mercadeo if (empresa.cod_fax_mercadeo).nil?
	fax_mercadeo = "" if (empresa.cod_fax_mercadeo.nil?) and (empresa.fax_mercadeo.nil?)
	return fax_mercadeo

 end


 def self.generar_excel
 	
 	# OJO si algun inner join falla puede que no se traiga los registros de empresa completo
    empresas = Empresa.where("estatus.descripcion = ?", 'Activa').joins("inner join estatus on empresa.id_estatus = estatus.id LEFT OUTER JOIN [BDGS1DTS.MDF].dbo.fnc_CltSlv () ON empresa.prefijo = [BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo").order("empresa.fecha_activacion desc").select("empresa.prefijo as prefijo, empresa.nombre_empresa as nombre_empresa, empresa.fecha_activacion as fecha_activacion, empresa.rif_completo as rif_completo, empresa.rif as rif, estatus.descripcion as estatus_, isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2)  AS solv, empresa.ventas_brutas_anuales as ventas_brutas_anuales, empresa.aporte_mantenimiento as aporte_mantenimiento, empresa.categoria as categoria, empresa.division as division, empresa.grupo as grupo, empresa.clase as clase, empresa.rep_legal as rep_legal, empresa.email1_ean as email1_ean, empresa.email2_ean as email2_ean, empresa.telefono1_ean as telefono1_ean, empresa.telefono2_ean as telefono2_ean, empresa.telefono3_ean as telefono3_ean, empresa.fax_ean as fax_ean, empresa.fecha_inscripcion as fecha_inscripcion, empresa.fecha_reactivacion as fecha_reactivacion, empresa.direccion_empresa as direccion_empresa, empresa.cod_contacto_tlf1 as cod_contacto_tlf1, empresa.contacto_tlf1 as contacto_tlf1, empresa.cod_contacto_tlf2 as cod_contacto_tlf2, empresa.contacto_tlf2 as contacto_tlf2, empresa.cod_contacto_tlf3 as cod_contacto_tlf3, empresa.contacto_tlf3 as contacto_tlf3, empresa.cod_contacto_fax as cod_contacto_fax, empresa.contacto_fax as contacto_fax, empresa.cod_tlf1_ean as cod_tlf1_ean, empresa.telefono1_ean as telefono1_ean, empresa.cod_tlf2_ean as cod_tlf2_ean, empresa.telefono2_ean as telefono2_ean, empresa.cod_tlf3_ean as cod_tlf3_ean, empresa.telefono3_ean as telefono3_ean, empresa.cod_fax_ean as cod_fax_ean, empresa.fax_ean as fax_ean, empresa.cod_tlf1_sincronet as cod_tlf1_sincronet, empresa.telefono1_edi as telefono1_edi, empresa.cod_tlf2_sincronet as cod_tlf2_sincronet, empresa.telefono2_edi as telefono2_edi, empresa.cod_tlf3_sincronet as cod_tlf3_sincronet, empresa.telefono3_edi as telefono3_edi, empresa.cod_fax_sincronet as cod_fax_sincronet, empresa.fax_edi as fax_edi, empresa.email1_edi as email1_edi, empresa.email2_edi as email2_edi, empresa.cod_tlf1_seminarios as cod_tlf1_seminarios, empresa.telefono1_recursos as telefono1_recursos, empresa.cod_tlf2_seminarios as cod_tlf2_seminarios, empresa.telefono2_recursos as telefono2_recursos, empresa.cod_tlf3_seminarios as cod_tlf3_seminarios, empresa.telefono3_recursos as telefono3_recursos, empresa.cod_fax_seminarios as cod_fax_seminarios, empresa.fax_recursos as fax_recursos, empresa.cod_tlf1_mercadeo as cod_tlf1_mercadeo, empresa.telefono1_mercadeo as telefono1_mercadeo, empresa.cod_tlf2_mercadeo as cod_tlf2_mercadeo, empresa.telefono2_mercadeo as telefono2_mercadeo, empresa.cod_tlf3_mercadeo as cod_tlf3_mercadeo, empresa.telefono3_mercadeo as telefono3_mercadeo, empresa.cod_fax_mercadeo as cod_fax_mercadeo, empresa.fax_mercadeo as fax_mercadeo, empresa.contacto_email1 as contacto_email1, empresa.contacto_email2 as contacto_email2, empresa.email1_recursos as email1_recursos, empresa.email2_recursos as email2_recursos, empresa.email1_mercadeo as email1_mercadeo, empresa.email2_mercadeo as email2_mercadeo")
	GenerarExcelController.new.show(empresas)

 end



end
