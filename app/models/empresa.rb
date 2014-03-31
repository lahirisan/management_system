class Empresa < ActiveRecord::Base
  self.table_name = "empresa"  # El nombre de la tabla que se esta mapeando
  has_one :correspondencia, :foreign_key => "prefijo"
  accepts_nested_attributes_for :correspondencia, :allow_destroy => true # Maneja el modelo correspondencia en el formulario de empresa
  attr_accessible :cargo_rep_legal, :categoria, :clase, :direccion_empresa, :division, :fecha_inscripcion, :grupo, :id_ciudad, :id_clasificacion, :id_estado, :id_estatus, :id_tipo_usuario, :nombre_comercial, :nombre_empresa, :rep_legal, :rif, :prefijo,  :correspondencia_attributes # Los atributos de correspondecia
  
  belongs_to :estado, :foreign_key =>  "id_estado"  # Se establece la clave foranea por la cual va a buscar la asociacion
  belongs_to :ciudad, :foreign_key =>  "id_ciudad"  
  belongs_to :estatus, :foreign_key =>  "id_estatus"
  belongs_to :clasificacion, :foreign_key => "id_clasificacion"
  has_one  :empresas_retiradas,  :foreign_key => "prefijo"
  
  validates :nombre_empresa, :fecha_inscripcion, :direccion_empresa, :id_estado, :id_ciudad, :rif, :prefijo,   :presence => {:message => "No puede estar en blanco"}
  validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{8})-([0-9]{1})$/, on: :create, :message => "El Formato del RIF es invalido"} # Validacion al crear
  #validates :rif, format: { with: /^(v|V|e|E|j|J|g|G)-([0-9]{8})-([0-9]{1})$/, on: :update, :message => "El Formato del RIF es invalido"} # Validacion al editar


  def self.to_csv # Se genera el CSV de Empresas

  	CSV.generate do |csv|
  		all.each do |empresa|
  			csv << empresa.attributes.values_at(*column_names)
  		end
    end 
  end

  def self.validar_empresas(empresas) # Procedimiento para validar Empresas
    @estatus_activa = Estatus.find(:first, :conditions => ["descripcion like ?", "Activa"]) # Se busca el ID de Estatus Activa
    @empresas = Empresa.find(:all, :conditions => ["prefijo in (?)", empresas.collect{|prefijo| prefijo}])
    @empresas.collect{|empresa_seleccionada| empresa = Empresa.find(empresa_seleccionada.prefijo); empresa.id_estatus = @estatus_activa.id; empresa.save}
  end

  def self.retirar_empresas(parametros)
    raise "retirar_empresa".to_yaml
    #En el parametro activar empresa estan cada uno de los ID de las empresas que se van a retirar. A su vez ese es el nombre del input asociado a la empresa y tiene el valor de los campos sub-estatus y motivo-retiro
    # OJO: Esto se peude optimizar actualizando masivamente // RailCast 198

      for retirar_empresas in (0..parametros[:retirar_empresas].size-1)
        empresa_seleccionada = parametros[:retirar_empresas][retirar_empresas]
        retirar_datos = parametros[:"#{empresa_seleccionada}"]
        retirar_datos.split('_')[0] # retirar_datos.split('_')[0] Prefijo de la empresa retirar_datos.split('_')[1] id sub_estatus retirar_datos.split('_')[2] id motivo_retiro
        
        # Si al empresa existe se edita, sino se crea el registro
        empresa_retirar = EmpresasRetiradas.find(:first, :conditions => ["prefijo = ?",retirar_datos.split('_')[0]])
        empresa_retirar =  EmpresasRetiradas.new if  empresa_retirar.nil?

        empresa_retirar.prefijo = retirar_datos.split('_')[0]
        fecha_retiro = Time.now
        empresa_retirar.fecha_retiro = fecha_retiro
        empresa_retirar.id_motivo_retiro = retirar_datos.split('_')[2]
        empresa_retirar.id_subestatus = retirar_datos.split('_')[1]
        empresa_retirar.save

        # Se cambia el estatus de la empresa
        empresa = Empresa.find(retirar_datos.split('_')[0])
        # El estatus de retirada
        estatus_retirada = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", 'Retirada', 'Empresa'])
        empresa.id_estatus = estatus_retirada.id
        empresa.save

      end
  end


  def self.retirar_empresas_masivo(parametros)
    
    raise "retirar_empresa_masivo".to_yaml

    for retirar_empresas in (0..parametros[:retirar_empresas].size-1)
        empresa_seleccionada = parametros[:retirar_empresas][retirar_empresas]
        retirar_datos = parametros[:"#{empresa_seleccionada}"]
        retirar_datos.split('_')[0] # retirar_datos.split('_')[0] Prefijo de la empresa retirar_datos.split('_')[1] id sub_estatus retirar_datos.split('_')[2] id motivo_retiro
        
        # Si al empresa existe se edita, sino se crea el registro
        empresa_retirar = EmpresasRetiradas.find(:first, :conditions => ["prefijo = ?",retirar_datos.split('_')[0]])
        empresa_retirar =  EmpresasRetiradas.new if  empresa_retirar.nil?

        empresa_retirar.prefijo = retirar_datos.split('_')[0]
        fecha_retiro = Time.now
        empresa_retirar.fecha_retiro = fecha_retiro
        empresa_retirar.id_motivo_retiro = parametros[:motivo_retiro].to_i
        empresa_retirar.id_subestatus = parametros[:sub_estatus].to_i
        empresa_retirar.save

        # Se cambia el estatus de la empresa
        empresa = Empresa.find(retirar_datos.split('_')[0])
        # El estatus de retirada
        estatus_retirada = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", 'Retirada', 'Empresa'])
        empresa.id_estatus = estatus_retirada.id
        empresa.save

      end
  end

  def self.eliminar_empresas(parametros)
    
    raise "elimianr_empresa".to_yaml
    #En el parametro activar empresa estan cada uno de los ID de las empresas que se van a retirar. A su vez ese es el nombre del input asociado a la empresa y tiene el valor de los campos sub-estatus y motivo-retiro
    # OJO: Esto se peude optimizar actualizando masivamente // RailCast 198

      for retirar_empresas in (0..parametros[:retirar_empresas].size-1)
        empresa_seleccionada = parametros[:retirar_empresas][retirar_empresas]
        retirar_datos = parametros[:"#{empresa_seleccionada}"]
        retirar_datos.split('_')[0] # retirar_datos.split('_')[0] Prefijo de la empresa retirar_datos.split('_')[1] id sub_estatus retirar_datos.split('_')[2] id motivo_retiro
        
        # Si al empresa existe se edita, sino se crea el registro
        empresa_retirar = EmpresasRetiradas.find(:first, :conditions => ["prefijo = ?",retirar_datos.split('_')[0]])
        empresa_retirar =  EmpresasRetiradas.new if  empresa_retirar.nil?

        empresa_retirar.prefijo = retirar_datos.split('_')[0]
        fecha_retiro = Time.now
        empresa_retirar.fecha_retiro = fecha_retiro
        empresa_retirar.id_motivo_retiro = retirar_datos.split('_')[2]
        empresa_retirar.id_subestatus = retirar_datos.split('_')[1]
        empresa_retirar.save

        # Se cambia el estatus de la empresa
        empresa = Empresa.find(retirar_datos.split('_')[0])
        # El estatus de retirada
        estatus_retirada = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", 'Retirada', 'Empresa'])
        empresa.id_estatus = estatus_retirada.id
        empresa.save

      end
  end


  def self.eliminar_empresas_masivo(parametros)
    
    raise "eliminar_empresa_masivo".to_yaml

    for retirar_empresas in (0..parametros[:retirar_empresas].size-1)
        empresa_seleccionada = parametros[:retirar_empresas][retirar_empresas]
        retirar_datos = parametros[:"#{empresa_seleccionada}"]
        retirar_datos.split('_')[0] # retirar_datos.split('_')[0] Prefijo de la empresa retirar_datos.split('_')[1] id sub_estatus retirar_datos.split('_')[2] id motivo_retiro
        
        # Si al empresa existe se edita, sino se crea el registro
        empresa_retirar = EmpresasRetiradas.find(:first, :conditions => ["prefijo = ?",retirar_datos.split('_')[0]])
        empresa_retirar =  EmpresasRetiradas.new if  empresa_retirar.nil?

        empresa_retirar.prefijo = retirar_datos.split('_')[0]
        fecha_retiro = Time.now
        empresa_retirar.fecha_retiro = fecha_retiro
        empresa_retirar.id_motivo_retiro = parametros[:motivo_retiro].to_i
        empresa_retirar.id_subestatus = parametros[:sub_estatus].to_i
        empresa_retirar.save

        # Se cambia el estatus de la empresa
        empresa = Empresa.find(retirar_datos.split('_')[0])
        # El estatus de retirada
        estatus_retirada = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", 'Retirada', 'Empresa'])
        empresa.id_estatus = estatus_retirada.id
        empresa.save

      end
  end

end
