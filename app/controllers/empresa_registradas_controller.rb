#encoding: UTF-8
class EmpresaRegistradasController < ApplicationController
  # GET /empresa_registradas
  # GET /empresa_registradas.json
  def index

    @empresa_registradas = EmpresaRegistrada.all

    respond_to do |format|
      
      format.html {

        if params[:activar_solvencia] 

          render :template =>'/empresa_registradas/activar_solvencia.html.haml'

        else
          
          if params[:activar_empresa]

            
            @ruta = "/empresa_registradas.json?activar_empresa=true"
          else
              @ruta = "/empresa_registradas.json"
          end

          render :template => '/empresa_registradas/index.html.haml'

        end 
      }

      format.json {
        
        
        if params[:activar_solvencia]

          render json: (EmpresaRegistradasActivarSolvenciaDatatable.new(view_context)) 
        else

          render json: (EmpresaRegistradasDatatable.new(view_context, session[:perfil], session[:gerencia])) 
        end

      }

    end
  end

  # GET /empresa_registradas/1
  # GET /empresa_registradas/1.json
  def show

    @empresa_registrada = EmpresaRegistrada.find(params[:id])
    @telefono1 = Empresa.telefono1(@empresa_registrada)
    @telefono2 = Empresa.telefono2(@empresa_registrada)
    @telefono3 = Empresa.telefono3(@empresa_registrada)
    @fax = Empresa.fax(@empresa_registrada)
    
    
    @estado_ean = Estado.find(@empresa_registrada.id_estado_ean) if (@empresa_registrada.id_estado_ean) and (@empresa_registrada.id_estado_ean >= 1 and @empresa_registrada.id_estado_ean <= 25)
    @ciudad_ean = Ciudad.find(@empresa_registrada.id_ciudad_ean) if (@empresa_registrada.id_ciudad_ean) and (@empresa_registrada.id_ciudad_ean >= 1 and   @empresa_registrada.id_ciudad_ean <= 601)
    @municipio_ean = Municipio.find(@empresa_registrada.id_municipio_ean) if (@empresa_registrada.id_municipio_ean) and (@empresa_registrada.id_municipio_ean >= 1 and @empresa_registrada.id_municipio_ean <= 365)
    @telefono1_ean = Empresa.telefono1_ean(@empresa_registrada)
    @telefono2_ean = Empresa.telefono2_ean(@empresa_registrada)
    @telefono3_ean = Empresa.telefono3_ean(@empresa_registrada)
    @fax_ean = Empresa.fax_ean(@empresa_registrada)

    @estado_edi = Estado.find(@empresa_registrada.id_estado_edi) if (@empresa_registrada.id_estado_edi) and (@empresa_registrada.id_estado_edi >= 1 and @empresa_registrada.id_estado_edi <= 25)
    @ciudad_edi = Ciudad.find(@empresa_registrada.id_ciudad_edi) if (@empresa_registrada.id_ciudad_edi) and (@empresa_registrada.id_ciudad_edi >= 1 and   @empresa_registrada.id_ciudad_edi <= 601)
    @municipio_edi = Municipio.find(@empresa_registrada.id_municipio_edi) if (@empresa_registrada.id_municipio_edi) and  (@empresa_registrada.id_municipio_edi >= 1 and @empresa_registrada.id_municipio_edi <= 365)
    @telefono1_edi = Empresa.telefono1_edi(@empresa_registrada)
    @telefono2_edi = Empresa.telefono2_edi(@empresa_registrada)
    @telefono3_edi = Empresa.telefono3_edi(@empresa_registrada)
    @fax_edi = Empresa.fax_edi(@empresa_registrada)

   
    @telefono1_recursos = Empresa.telefono1_recursos(@empresa_registrada)
    @fax_recursos = Empresa.fax_recursos(@empresa_registrada)
    
    @telefono1_mercadeo = Empresa.telefono1_mercadeo(@empresa_registrada)
    @fax_mercadeo = Empresa.fax_mercadeo(@empresa_registrada)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /empresa_registradas/new
  # GET /empresa_registradas/new.json
  def new
    @empresa_registrada = EmpresaRegistrada.new
    @opciones = ['J', 'G', 'E', 'V']
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /empresa_registradas/1/edit
  def edit

    @empresa_registrada = EmpresaRegistrada.find(params[:id])
    @clasificacion = Clasificacion.where("categoria = '#{@empresa_registrada.categoria}' and division = #{@empresa_registrada.division} and grupo = #{@empresa_registrada.grupo} and clase = #{@empresa_registrada.clase}").first
         
    respond_to do |format|

      format.html{
        
        if params[:activar_empresa]
          
          @prefijo = Empresa.generar_prefijo_valido
          @clasificacion_empresa = Clasificacion.find(:first, :conditions => ["categoria = ? and division = ? and grupo = ? and clase = ?", @empresa_registrada.categoria, @empresa_registrada.division, @empresa_registrada.grupo, @empresa_registrada.clase])
          @prefijos_disponibles = EmpresaEliminada.find(:all, :include => [:estatus], :conditions => ["(categoria = ? or division = ? or grupo = ? or clase = ?) and no_elejible is ? and prefijo >= 7590000 and prefijo <= 7599999", @empresa_registrada.categoria, @empresa_registrada.division, @empresa_registrada.grupo, @empresa_registrada.clase, nil], :select => "empresa.prefijo, empresa.nombre_empresa, clasificacion.descripcion, estatus.descripcion")

          # Se busca el prefijo encontrado contra el sistema adminsitrativo para asegurarse que este disponible
          @prefijo_asignado_administrativo = Empresa.find_by_sql " Select * from [BDGS1DTS.MDF].dbo.CC_Clientes where codigo = #{@prefijo}"

          flash[:warning] = "La Aplicación detectó que el prefijo disponible en Sistema de Gestión #{@prefijo} se encuentra asignado en la Base de Datos del Sistema Administrativo. De continuar se producirá un error. Se sugiere que asigne el prefijo manual, y verifique que no se encuentre ya asignado en Sistema Administrativo." if !(@prefijo_asignado_administrativo.empty?)

          # Este template no permite la edicion de la empresa. Respetando el alcance del usuario segun privilegio
          render :template => '/empresa_registradas/activar_empresa.html.haml'


        end


        
      }

    end 
    
  end

  # POST /empresa_registradas
  # POST /empresa_registradas.json
  def create

    params[:empresa_registrada][:id_estatus] = 5 # NO VALIDADA (SIN PREFIJO)
    params[:empresa_registrada][:id_subestatus] = 2 # NO SOLVENTE
    params[:empresa_registrada][:fecha_inscripcion] = Time.now
    
    # DATOS BASICOS EMPRESA SE LLEVAN A MAYUSCULAS

    params[:empresa_registrada][:nombre_empresa] = params[:empresa_registrada][:nombre_empresa].upcase if params[:empresa_registrada][:nombre_empresa]
    params[:empresa_registrada][:nombre_comercial] =  params[:empresa_registrada][:nombre_comercial].upcase if params[:empresa_registrada][:nombre_comercial]
    params[:empresa_registrada][:direccion_empresa] = params[:empresa_registrada][:direccion_empresa].upcase if params[:empresa_registrada][:direccion_empresa]
    params[:empresa_registrada][:circunscripcion_judicial] = params[:empresa_registrada][:circunscripcion_judicial].upcase if params[:empresa_registrada][:circunscripcion_judicial]
    params[:empresa_registrada][:rep_legal] = params[:empresa_registrada][:rep_legal].upcase if params[:empresa_registrada][:rep_legal]
    params[:empresa_registrada][:cargo_rep_legal] = params[:empresa_registrada][:cargo_rep_legal].upcase if params[:empresa_registrada][:cargo_rep_legal]
    params[:empresa_registrada][:nacionalidad_responsable_legal] = params[:empresa_registrada][:nacionalidad_responsable_legal].upcase if params[:empresa_registrada][:nacionalidad_responsable_legal]
    params[:empresa_registrada][:domicilio_responsable_legal] = params[:empresa_registrada][:domicilio_responsable_legal].upcase if params[:empresa_registrada][:domicilio_responsable_legal]


    # DATOS EAN SE LLEVAN A MAYUSCULAS

    params[:empresa_registrada][:rep_ean] = params[:empresa_registrada][:rep_ean].upcase if params[:empresa_registrada][:rep_ean]
    params[:empresa_registrada][:rep_ean_cargo] = params[:empresa_registrada][:rep_ean_cargo].upcase if params[:empresa_registrada][:rep_ean_cargo]
    params[:empresa_registrada][:galpon_edificio_quinta] = params[:empresa_registrada][:galpon_edificio_quinta].upcase if params[:empresa_registrada][:galpon_edificio_quinta]
    params[:empresa_registrada][:oficina_apartamento] = params[:empresa_registrada][:oficina_apartamento].upcase if params[:empresa_registrada][:oficina_apartamento]
    params[:empresa_registrada][:avenida_calle] = params[:empresa_registrada][:avenida_calle].upcase if params[:empresa_registrada][:avenida_calle]
    params[:empresa_registrada][:urbanizacion_barrio_sector] = params[:empresa_registrada][:urbanizacion_barrio_sector].upcase if params[:empresa_registrada][:urbanizacion_barrio_sector]
    params[:empresa_registrada][:parroquia_ean] = params[:empresa_registrada][:parroquia_ean].upcase if params[:empresa_registrada][:parroquia_ean]
    params[:empresa_registrada][:punto_ref_ean] = params[:empresa_registrada][:punto_ref_ean].upcase if params[:empresa_registrada][:punto_ref_ean]


    # DATOS CORREO ELECTRONICO Y SINCRONET SE LLEVAN A MAYUSCULAS

    params[:empresa_registrada][:rep_edi] = params[:empresa_registrada][:rep_edi].upcase if params[:empresa_registrada][:rep_edi]
    params[:empresa_registrada][:rep_edi_cargo] = params[:empresa_registrada][:rep_edi_cargo].upcase if params[:empresa_registrada][:rep_edi_cargo]
    params[:empresa_registrada][:galpon_edificio_quinta_sincronet] = params[:empresa_registrada][:galpon_edificio_quinta_sincronet].upcase if params[:empresa_registrada][:galpon_edificio_quinta_sincronet]
    params[:empresa_registrada][:piso_numero_sincronet] =  params[:empresa_registrada][:piso_numero_sincronet].upcase if params[:empresa_registrada][:piso_numero_sincronet]
    params[:empresa_registrada][:oficina_apartamento_sincronet] = params[:empresa_registrada][:oficina_apartamento_sincronet].upcase if params[:empresa_registrada][:oficina_apartamento_sincronet]
    params[:empresa_registrada][:avenida_calle_sincronet] = params[:empresa_registrada][:avenida_calle_sincronet].upcase if params[:empresa_registrada][:avenida_calle_sincronet]
    params[:empresa_registrada][:urbanizacion_barrio_sector_sincronet] = params[:empresa_registrada][:urbanizacion_barrio_sector_sincronet].upcase if params[:empresa_registrada][:urbanizacion_barrio_sector_sincronet]
    params[:empresa_registrada][:parroquia_edi] = params[:empresa_registrada][:parroquia_edi].upcase if params[:empresa_registrada][:parroquia_edi]
    params[:empresa_registrada][:punto_ref_edi] = params[:empresa_registrada][:punto_ref_edi].upcase if params[:empresa_registrada][:punto_ref_edi]

    
    # DATOS RECURSOS SE LLEVAN A MAYUSCULA    
    
    params[:empresa_registrada][:rep_recursos] = params[:empresa_registrada][:rep_recursos].upcase if params[:empresa_registrada][:rep_recursos]
    params[:empresa_registrada][:rep_recursos_cargo] = params[:empresa_registrada][:rep_recursos_cargo].upcase if params[:empresa_registrada][:rep_recursos_cargo]

    # DATOS MERCADEO SE LLEVAN A MAYUSCULA

    params[:empresa_registrada][:rep_mercadeo] = params[:empresa_registrada][:rep_mercadeo].upcase if params[:empresa_registrada][:rep_mercadeo]
    params[:empresa_registrada][:rep_mercadeo_cargo] = params[:empresa_registrada][:rep_mercadeo_cargo].upcase if params[:empresa_registrada][:rep_mercadeo_cargo]
    
    # Se obtienen los numeros completos

    params[:empresa_registrada][:contacto_tlf1_completo] =  "("+ params[:empresa_registrada][:cod_contacto_tlf1] + ")" +" "+ params[:empresa_registrada][:contacto_tlf1] if params[:empresa_registrada][:cod_contacto_tlf1] != ""
    params[:empresa_registrada][:contacto_tlf2_completo] = "("+ params[:empresa_registrada][:cod_contacto_tlf2] + ")"+ " " + params[:empresa_registrada][:contacto_tlf2] if params[:empresa_registrada][:cod_contacto_tlf2] != ""
    params[:empresa_registrada][:contacto_tlf3_completo] ="("+ params[:empresa_registrada][:cod_contacto_tlf3] + ")" +" "+ params[:empresa_registrada][:contacto_tlf3] if params[:empresa_registrada][:cod_contacto_tlf3] != ""
    params[:empresa_registrada][:contacto_fax_completo] = "("+params[:empresa_registrada][:cod_contacto_fax] + ")" +" "+ params[:empresa_registrada][:contacto_fax] if params[:empresa_registrada][:cod_contacto_fax] != ""
    params[:empresa_registrada][:direccion_ean] = params[:empresa_registrada][:tipo_urbanizacion_barrio_sector] + " " + params[:empresa_registrada][:urbanizacion_barrio_sector] + " " + params[:empresa_registrada][:tipo_avenida_calle]  + " " + params[:empresa_registrada][:avenida_calle] + " " + params[:empresa_registrada][:tipo_galpon_edificio_quinta] + " " + params[:empresa_registrada][:galpon_edificio_quinta] + " " + params[:empresa_registrada][:tipo_piso_numero] + " " + params[:empresa_registrada][:piso_numero]  + " " + params[:empresa_registrada][:tipo_oficina_apartamento] + " " + params[:empresa_registrada][:oficina_apartamento] 
    params[:empresa_registrada][:telefono1_ean_completo] = "("+ params[:empresa_registrada][:cod_tlf1_ean] + ")" +" "+ params[:empresa_registrada][:telefono1_ean] if params[:empresa_registrada][:cod_tlf1_ean] != ""
    params[:empresa_registrada][:telefono2_ean_completo] = "("+ params[:empresa_registrada][:cod_tlf2_ean] + ")" +" "+ params[:empresa_registrada][:telefono2_ean] if params[:empresa_registrada][:cod_tlf2_ean] != ""
    params[:empresa_registrada][:telefono3_ean_completo] = "("+ params[:empresa_registrada][:cod_tlf3_ean] + ")" +" "+ params[:empresa_registrada][:telefono3_ean] if params[:empresa_registrada][:cod_tlf3_ean] != ""
    params[:empresa_registrada][:fax_ean_completo] = "("+ params[:empresa_registrada][:cod_fax_ean] + ")" +" "+ params[:empresa_registrada][:fax_ean]              if params[:empresa_registrada][:cod_fax_ean] != ""  


    params[:empresa_registrada][:rif_completo] = params[:empresa_registrada][:tipo_rif] + "-" + params[:empresa_registrada][:rif]

    @empresa_registrada = EmpresaRegistrada.new(params[:empresa_registrada])


    respond_to do |format|
      if @empresa_registrada.save
        
        # Se registra el evento de quien creo la empresa
        Auditoria.registrar_evento(session[:usuario],"empresa_registradas", "Crear", Time.now, "Empresa:#{@empresa_registrada.nombre_empresa} RIF:#{@empresa_registrada.rif}")

        format.html { redirect_to "/empresa_registradas", notice: "Empresa:#{@empresa_registrada.nombre_empresa} RIF:#{@empresa_registrada.rif_completo} registrada satisfactoriamente." }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /empresa_registradas/1
  # PUT /empresa_registradas/1.json
  def update

    @empresa_registrada = EmpresaRegistrada.find(params[:id])

    if params[:activar].nil?   # El parametro activar indica que no se esta actualñizando datos sino activando empresa

      @empresa_registrada.fecha_ultima_modificacion = Time.now # Se registra la fecha en que se edita la empresa
      
      # DATOS BASICOS EMPRESA SE LLEVAN A MAYUSCULAS

      params[:empresa_registrada][:nombre_empresa] = params[:empresa_registrada][:nombre_empresa].upcase if params[:empresa_registrada][:nombre_empresa]
      params[:empresa_registrada][:nombre_comercial] =  params[:empresa_registrada][:nombre_comercial].upcase if params[:empresa_registrada][:nombre_comercial]
      params[:empresa_registrada][:direccion_empresa] = params[:empresa_registrada][:direccion_empresa].upcase if params[:empresa_registrada][:direccion_empresa]
      params[:empresa_registrada][:circunscripcion_judicial] = params[:empresa_registrada][:circunscripcion_judicial].upcase if params[:empresa_registrada][:circunscripcion_judicial]
      params[:empresa_registrada][:rep_legal] = params[:empresa_registrada][:rep_legal].upcase if params[:empresa_registrada][:rep_legal]
      params[:empresa_registrada][:cargo_rep_legal] = params[:empresa_registrada][:cargo_rep_legal].upcase if params[:empresa_registrada][:cargo_rep_legal]
      params[:empresa_registrada][:nacionalidad_responsable_legal] = params[:empresa_registrada][:nacionalidad_responsable_legal].upcase if params[:empresa_registrada][:nacionalidad_responsable_legal]
      params[:empresa_registrada][:domicilio_responsable_legal] = params[:empresa_registrada][:domicilio_responsable_legal].upcase if params[:empresa_registrada][:domicilio_responsable_legal]


      # DATOS EAN SE LLEVAN A MAYUSCULAS

      params[:empresa_registrada][:rep_ean] = params[:empresa_registrada][:rep_ean].upcase if params[:empresa_registrada][:rep_ean]
      params[:empresa_registrada][:rep_ean_cargo] = params[:empresa_registrada][:rep_ean_cargo].upcase if params[:empresa_registrada][:rep_ean_cargo]
      params[:empresa_registrada][:galpon_edificio_quinta] = params[:empresa_registrada][:galpon_edificio_quinta].upcase if params[:empresa_registrada][:galpon_edificio_quinta]
      params[:empresa_registrada][:oficina_apartamento] = params[:empresa_registrada][:oficina_apartamento].upcase if params[:empresa_registrada][:oficina_apartamento]
      params[:empresa_registrada][:avenida_calle] = params[:empresa_registrada][:avenida_calle].upcase if params[:empresa_registrada][:avenida_calle]
      params[:empresa_registrada][:urbanizacion_barrio_sector] = params[:empresa_registrada][:urbanizacion_barrio_sector].upcase if params[:empresa_registrada][:urbanizacion_barrio_sector]
      params[:empresa_registrada][:parroquia_ean] = params[:empresa_registrada][:parroquia_ean].upcase if params[:empresa_registrada][:parroquia_ean]
      params[:empresa_registrada][:punto_ref_ean] = params[:empresa_registrada][:punto_ref_ean].upcase if params[:empresa_registrada][:punto_ref_ean]


      # DATOS CORREO ELECTRONICO Y SINCRONET SE LLEVAN A MAYUSCULAS

      params[:empresa_registrada][:rep_edi] = params[:empresa_registrada][:rep_edi].upcase if params[:empresa_registrada][:rep_edi]
      params[:empresa_registrada][:rep_edi_cargo] = params[:empresa_registrada][:rep_edi_cargo].upcase if params[:empresa_registrada][:rep_edi_cargo]
      params[:empresa_registrada][:galpon_edificio_quinta_sincronet] = params[:empresa_registrada][:galpon_edificio_quinta_sincronet].upcase if params[:empresa_registrada][:galpon_edificio_quinta_sincronet]
      params[:empresa_registrada][:piso_numero_sincronet] =  params[:empresa_registrada][:piso_numero_sincronet].upcase if params[:empresa_registrada][:piso_numero_sincronet]
      params[:empresa_registrada][:oficina_apartamento_sincronet] = params[:empresa_registrada][:oficina_apartamento_sincronet].upcase if params[:empresa_registrada][:oficina_apartamento_sincronet]
      params[:empresa_registrada][:avenida_calle_sincronet] = params[:empresa_registrada][:avenida_calle_sincronet].upcase if params[:empresa_registrada][:avenida_calle_sincronet]
      params[:empresa_registrada][:urbanizacion_barrio_sector_sincronet] = params[:empresa_registrada][:urbanizacion_barrio_sector_sincronet].upcase if params[:empresa_registrada][:urbanizacion_barrio_sector_sincronet]
      params[:empresa_registrada][:parroquia_edi] = params[:empresa_registrada][:parroquia_edi].upcase if params[:empresa_registrada][:parroquia_edi]
      params[:empresa_registrada][:punto_ref_edi] = params[:empresa_registrada][:punto_ref_edi].upcase if params[:empresa_registrada][:punto_ref_edi]

      
      # DATOS RECURSOS SE LLEVAN A MAYUSCULA    
      
      params[:empresa_registrada][:rep_recursos] = params[:empresa_registrada][:rep_recursos].upcase if params[:empresa_registrada][:rep_recursos]
      params[:empresa_registrada][:rep_recursos_cargo] = params[:empresa_registrada][:rep_recursos_cargo].upcase if params[:empresa_registrada][:rep_recursos_cargo]

      # DATOS MERCADEO SE LLEVAN A MAYUSCULA

      params[:empresa_registrada][:rep_mercadeo] = params[:empresa_registrada][:rep_mercadeo].upcase if params[:empresa_registrada][:rep_mercadeo]
      params[:empresa_registrada][:rep_mercadeo_cargo] = params[:empresa_registrada][:rep_mercadeo_cargo].upcase if params[:empresa_registrada][:rep_mercadeo_cargo]
      
      # Se obtienen los numeros completos

      params[:empresa_registrada][:contacto_tlf1_completo] =  "("+ params[:empresa_registrada][:cod_contacto_tlf1] + ")" +" "+ params[:empresa_registrada][:contacto_tlf1] if params[:empresa_registrada][:cod_contacto_tlf1] != ""
      params[:empresa_registrada][:contacto_tlf2_completo] = "("+ params[:empresa_registrada][:cod_contacto_tlf2] + ")"+ " " + params[:empresa_registrada][:contacto_tlf2] if params[:empresa_registrada][:cod_contacto_tlf2] != ""
      params[:empresa_registrada][:contacto_tlf3_completo] ="("+ params[:empresa_registrada][:cod_contacto_tlf3] + ")" +" "+ params[:empresa_registrada][:contacto_tlf3] if params[:empresa_registrada][:cod_contacto_tlf3] != ""
      params[:empresa_registrada][:contacto_fax_completo] = "("+params[:empresa_registrada][:cod_contacto_fax] + ")" +" "+ params[:empresa_registrada][:contacto_fax] if params[:empresa_registrada][:cod_contacto_fax] != ""
      params[:empresa_registrada][:direccion_ean] = params[:empresa_registrada][:tipo_urbanizacion_barrio_sector] + " " + params[:empresa_registrada][:urbanizacion_barrio_sector] + " " + params[:empresa_registrada][:tipo_avenida_calle]  + " " + params[:empresa_registrada][:avenida_calle] + " " + params[:empresa_registrada][:tipo_galpon_edificio_quinta] + " " + params[:empresa_registrada][:galpon_edificio_quinta] + " " + params[:empresa_registrada][:tipo_piso_numero] + " " + params[:empresa_registrada][:piso_numero]  + " " + params[:empresa_registrada][:tipo_oficina_apartamento] + " " + params[:empresa_registrada][:oficina_apartamento] 
      params[:empresa_registrada][:telefono1_ean_completo] = "("+ params[:empresa_registrada][:cod_tlf1_ean] + ")" +" "+ params[:empresa_registrada][:telefono1_ean] if params[:empresa_registrada][:cod_tlf1_ean] != ""
      params[:empresa_registrada][:telefono2_ean_completo] = "("+ params[:empresa_registrada][:cod_tlf2_ean] + ")" +" "+ params[:empresa_registrada][:telefono2_ean] if params[:empresa_registrada][:cod_tlf2_ean] != ""
      params[:empresa_registrada][:telefono3_ean_completo] = "("+ params[:empresa_registrada][:cod_tlf3_ean] + ")" +" "+ params[:empresa_registrada][:telefono3_ean] if params[:empresa_registrada][:cod_tlf3_ean] != ""
      params[:empresa_registrada][:fax_ean_completo] = "("+ params[:empresa_registrada][:cod_fax_ean] + ")" +" "+ params[:empresa_registrada][:fax_ean]              if params[:empresa_registrada][:cod_fax_ean] != ""  

      # SE OBTIENE EL RIF COMPLETO

      params[:empresa_registrada][:rif_completo] = params[:empresa_registrada][:tipo_rif] + "-" + params[:empresa_registrada][:rif]

    end
    

    respond_to do |format|
      
      if params[:activar]  # Si se esta activando la empresa no se aactualiza los datos porque ese usuario no tiene el privilegio

        Empresa.activar(@empresa_registrada, params[:empresa_registrada][:prefijo])
        Auditoria.registrar_evento(session[:usuario],"", "Activar", Time.now,  "EMPRESA ACTIVADA. PREFIJO:#{@empresa_registrada.prefijo}")
        format.html { redirect_to "/empresa_registradas?activar_empresa=true", notice: "EMPRESA ACTIVADA. PREFIJO #{@empresa_registrada.prefijo} NOMBRE EMPRESA #{@empresa_registrada.nombre_empresa} RIF #{@empresa_registrada.rif_completo}" and return }

      else # Se actualizan los datos de la empresa privilegio asociado a Administracion - VEntas

        if @empresa_registrada.update_attributes(params[:empresa_registrada])
           
          Auditoria.registrar_evento(session[:usuario],"empresa_registradas", "Editar", Time.now, params[:empresa_registrada])
          format.html { redirect_to "/empresa_registradas", notice: "Los datos de la Empresa:#{@empresa_registrada.nombre_empresa} RIF:#{@empresa_registrada.rif_completo} fueron actualizados satisfactoriamente."  and return}
  
      
        else
          format.html { render action: "edit" }
      
        end

      end



    end
  end

  def update_multiple  ## Ruta para asignar SOLVENTE  a las nuevas empresas  metodo patch 
    

  
    nuevas_empresas = EmpresaRegistrada.find(params[:activar_solvencias])
    solvente = SubEstatus.find(:first, :conditions => ["descripcion = ?", "SOLVENTE"])

      nuevas_empresas.collect{|nueva_empresa| 
      nueva_empresa.id_subestatus = solvente.id; 
      nueva_empresa.save; 
      
      Auditoria.registrar_evento(session[:usuario],"empresa_registradas", "Asignar SOLVENTE", Time.now, "EMPRESA #{nueva_empresa.nombre_empresa}  RIF #{nueva_empresa.rif}")
    }

    respond_to do |format|
        
        # Se registra la persona que la nueva empresa como SOLVENTE

        format.html { redirect_to "/empresa_registradas?activar_solvencia=true", notice: "       Las empresas con RIF #{nuevas_empresas.collect{|nueva_empresa| nueva_empresa.rif_completo} } fueron marcadas como SOLVENTES."}
    
    end
  end

  # DELETE /empresa_registradas/1
  # DELETE /empresa_registradas/1.json
  def destroy
    @empresa_registrada = EmpresaRegistrada.find(params[:id])
    @empresa_registrada.destroy

    respond_to do |format|
      format.html { redirect_to empresa_registradas_url }
      format.json { head :no_content }
    end
  end
end

