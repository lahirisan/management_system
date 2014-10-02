#encoding: UTF-8

class EmpresasController < ApplicationController
  before_filter :require_authentication
  
  prawnto :prawn => { :top_margin => 10, :page_layout => :landscape} 
  
  # GET /empresas
  # GET /empresas.json
  
  def index

    # OJO: La llamada JSON y los parametro se establecen en el datatable desde el template.html.haml



    respond_to do |format|
      format.html{
                  
                  if params[:activacion]
                    render :template =>'/empresas/activacion.html.haml' 
                  elsif params[:retirar]
                    render :template =>'/empresas/retirar_empresa.html.haml'
                  elsif params[:eliminar]
                    render :template =>'/empresas/eliminar_empresa.html.haml'
                  elsif params[:eliminadas]
                    render :template =>'/empresas/empresas_eliminadas.html.haml'
                  elsif params[:retiradas] 
                    render :template =>'/empresas/empresas_retiradas.html.haml'
                  elsif params[:reactivar]
                    render :template =>'/empresas/empresas_reactivar.html.haml'
                  elsif params[:sub_estatus]
                    render :template =>'/empresas/sub_estatus.html.haml'
                  else
                    render :template =>'/empresas/index.html.haml'
                  end

      } # index.html.erb
      
      format.json { 

                    if (params[:activacion] == 'true')
                      render json: (ActivacionEmpresasDatatable.new(view_context))
                    elsif (params[:retirar] == 'true')
                      render json: (RetirarEmpresasDatatable.new(view_context))
                    elsif (params[:eliminar] == 'true')
                      render json: (EliminarEmpresasDatatable.new(view_context))
                    elsif (params[:eliminadas] == 'true')
                      render json: (EmpresasEliminadasDatatable.new(view_context))
                    elsif (params[:retiradas] == 'true')
                      render json: (EmpresasRetiradasDatatable.new(view_context))
                    elsif (params[:reactivar] == 'true')
                      render json: (ReactivarEmpresasDatatable.new(view_context))
                    elsif (params[:sub_estatus] == 'true')
                      render json: (EmpresasSubEstatusDatatable.new(view_context))
                    else
                      render json: (EmpresasDatatable.new(view_context))
                    end
                  }

      format.xlsx{

                  if params[:retiradas]
                    @empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, {:empresas_retiradas => :sub_estatus},{:empresas_retiradas => :motivo_retiro}).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("empresas_retiradas.fecha_retiro desc")
                    render  "/empresas/empresas_retiradas.xlsx.axlsx"

                  elsif params[:eliminadas]
                    @empresas = EmpresaEliminada.includes(:estado, :ciudad, :estatus, :clasificacion, :empresa_elim_detalle, :sub_estatus, :motivo_retiro).order("empresa_elim_detalle.fecha_eliminacion desc")
                    render "/empresas/empresas_eliminadas.xlsx.axlsx"
                  elsif params[:activacion]
                    @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:ciudad, :estatus, :tipo_usuario_empresa, :clasificacion).order("empresa.fecha_inscripcion")
                    render "/empresas/activacion_empresas.xlsx.axlsx"
                  else
                    @empresas = Empresa.includes( :estado, :ciudad, :estatus, :clasificacion, :sub_estatus).where("estatus.descripcion = ?", 'Activa').order("empresa.fecha_activacion desc")
                    render  "/empresas/index.xlsx.axlsx"
                  end 
      }

      format.pdf {


                if (params[:retiradas])
                  @empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, {:empresas_retiradas => :sub_estatus},{:empresas_retiradas => :motivo_retiro}).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("empresas_retiradas.fecha_retiro desc")
                  render "/empresas/empresas_retiradas.pdf.prawn"
                elsif params[:eliminadas]
                  @empresas = EmpresaEliminada.where("estatus.descripcion = ?", 'Eliminada').includes(:estado, :ciudad, :estatus, :clasificacion, :empresa_elim_detalle, :sub_estatus, :motivo_retiro).order("empresa_elim_detalle.fecha_eliminacion desc")
                  render "/empresas/empresas_eliminadas.pdf.prawn"
                elsif params[:activacion]
                  @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:ciudad, :estatus, :clasificacion, :tipo_usuario_empresa).order("empresa.fecha_inscripcion DESC")
                  render "/empresas/activacion_empresas.pdf.prawn"
                else
                  @empresas = Empresa.includes( :ciudad, :estatus, :clasificacion, :sub_estatus).where("estatus.descripcion = ?", 'Activa').order("empresa.fecha_activacion desc")
                  render "/empresas/index.pdf.prawn"
                end
      } 

    end

  end

  # GET /empresas/1
  # GET /empresas/1.json
  def show

    (params[:eliminados]) ? (@empresa = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:id]])) : (@empresa = Empresa.find(params[:id]))
    @datos_contactos = (params[:eliminados]) ? @empresa.empresa_contacto_eliminada : @empresa.datos_contacto
    #@correspondencia = (params[:eliminados]) ? @empresa.correspondencia_eliminada : @empresa.correspondencia

    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @empresa }
    end
  end

  # GET /empresas/new
  # GET /empresas/new.json
  def new

    @ultimo = Empresa.generar_prefijo_valido
    @empresa = Empresa.new
    
    #@empresa.datos_contacto.build   #Para que manejar los datos de la tabla empresa_contactos, mapeado por el modelo DatosContacto
    

    respond_to do |format|
      
      format.html {

        @prefijos_disponibles = EmpresaEliminada.find(:all, :include => [:estatus, :clasificacion],:select => "empresa.prefijo, empresa.nombre_empresa, clasificacion.descripcion, estatus.descripcion")
        @prefijos_disponibles1 = Empresa.find(:all, :conditions => ["estatus.descripcion = ?", 'No Validado'], :include => [:estatus,:clasificacion], :select => "empresa.prefijo, empresa.nombre_empresa, clasificacion.descripcion, estatus.descripcion")
        @prefijos_disponibles = @prefijos_disponibles.zip(@prefijos_disponibles1).flatten.compact

      }

      format.json {

        if params[:id_clasificacion]

          @prefijos_disponibles = EmpresaEliminada.find(:all, :include => [:estatus, :clasificacion],:select => "empresa.prefijo, empresa.nombre_empresa, clasificacion.descripcion, estatus.descripcion", :conditions => ["empresa_clasificacion.id = ?", params[:id_clasificacion]])
          @prefijos_disponibles1 = Empresa.find(:all, :conditions => ["estatus.descripcion = ?", 'No Validado'], :include => [:estatus,:clasificacion], :select => "empresa.prefijo, empresa.nombre_empresa, clasificacion.descripcion, estatus.descripcion", :conditions => ["empresa_clasificacion.id = ?", params[:id_clasificacion]])
          @prefijos_disponibles = @prefijos_disponibles.zip(@prefijos_disponibles1).flatten.compact
        
        end


        render json: @prefijos_disponibles}
    end
  end

  # GET /empresas/1/edit
  def edit
    @empresa = Empresa.find(params[:id])
    @clasificacion_empresa = Clasificacion.find(:first, :conditions => ["categoria = ? and division = ? and grupo = ? and clase = ?", @empresa.categoria, @empresa.division, @empresa.grupo, @empresa.clase])


  end

  # POST /empresas
  # POST /empresas.json
  def create

    
    #empresa_no_validada = Empresa.find(:first, :include => [:estatus], :conditions => ["prefijo = ? and estatus.descripcion = ?", params[:empresa][:prefijo], 'No Validado'])
    #prefijo_eliminado = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:empresa][:prefijo]])
    
    #Empresa.utilizar_prefijo_no_validado(empresa_no_validada) if empresa_no_validada

    @ultimo =  Empresa.generar_prefijo_valido   # OJO con estoooooooooooooo
    params[:empresa][:id_estatus] = Estatus.empresa_inactiva()
    # Se completa la hora con los segundos para que pueda ordenar por la ultima creada
    time = Time.now
    params[:empresa][:fecha_inscripcion] = Time.now
    @empresa = Empresa.new(params[:empresa])

    #params[:empresa][:datos_contacto_attributes][:"0"][:contacto] = params[:codigo_telefono1] + "-" + params[:empresa][:datos_contacto_attributes][:"0"][:contacto]

    params[:empresa][:id_tipo_usuario] = 3 if params[:empresa][:id_tipo_usuario] == '' # Si el usaurio no especifico el tipo de empresa

    
    respond_to do |format|
      
      params[:empresa][:contacto_tlf1] =  params[:codigo_telefono1] + "-" + params[:empresa][:contacto_tlf1] if params[:codigo_telefono1] != ""
      params[:empresa][:contacto_tlf2] = params[:codigo_telefono2] + "-" + params[:empresa][:contacto_tlf2] if params[:codigo_telefono2] != ""
      params[:empresa][:contacto_tlf3] = params[:codigo_telefono3] + "-" + params[:empresa][:contacto_tlf3] if params[:codigo_telefono3] != ""
      params[:empresa][:contacto_fax] = params[:codigo_telefono4] + "-" + params[:empresa][:contacto_fax] if params[:codigo_telefono4] != ""
      
      if @empresa.save
  
        
        # EL GLN OJO con esto  validar los casos GLN para empresa no validad y GLN de emrpresas eliminadas
        
        Gln.generar_legal(@empresa.prefijo.to_s) #if empresa_no_validada.nil?

        Auditoria.registrar_evento(session[:user_id],"Empresa", "Crear", Time.now, "Prefijo #{@empresa.prefijo}")
        format.html { 
         if session[:gerencia] == 'Estandares y Consultoría' or session[:perfil] == 'Administrador' or session[:perfil] == 'Super Usuario'
          redirect_to '/empresas?activacion=true', notice: "EMPRESA CREADA SATISFACTORIAMENTE. PREFIJO:#{@empresa.prefijo}   NOMBRE:#{@empresa.nombre_empresa}"
         else
          redirect_to '/empresas?activacion=true', notice: "EMPRESA CREADA SATISFACTORIAMENTE. NOMBRE:#{@empresa.nombre_empresa} RIF:#{@empresa.rif}"
         end
        }

       else
          format.html { render action: "new" }
       end
    end
  end

  # PUT /empresas/1
  # PUT /empresas/1.json
  def update


    @empresa = Empresa.find(params[:id])

    
    #@datos_contactos = (params[:eliminados]) ? @empresa.empresa_contacto_eliminada : @empresa.datos_contacto

    respond_to do |format|
      if @empresa.update_attributes(params[:empresa])

        # codificacionGS1 = Correspondencia.find(:first, :conditions => ["prefijo = ? and tipo_correspondencia = ?", @empresa.prefijo, "CODIFICACION GS1"])
        # sincronet = Correspondencia.find(:first, :conditions => ["prefijo = ? and tipo_correspondencia = ?", @empresa.prefijo, "COMERCIO ELECTRONICO / SINCRONET"])
        # seminarios = Correspondencia.find(:first, :conditions => ["prefijo = ? and tipo_correspondencia = ?", @empresa.prefijo, "SEMINARIOS / CURSOS"])
        # mercadeo = Correspondencia.find(:first, :conditions => ["prefijo = ? and tipo_correspondencia = ?", @empresa.prefijo, "MERCADEO"])

        
        
        # if (sincronet) # Se verifica si existe el tipo de correspondencia
        #   Correspondencia.modificar_correspondencia(@empresa.prefijo, params[:persona_contacto_sincronet], params[:cargo_sincronet], params[:edificio_sincronet], params[:detalle_edificio_sincronet], params[:piso_sincronet], params[:detalle_piso_sincronet], params[:oficina_sincronet], params[:detalle_oficina_sincronet], params[:calle_sincronet], params[:detalle_calle_sincronet], params[:urbanizacion_sincronet], params[:detalle_urbanizacion_sincronet], params[:estado_sincronet], params[:ciudad_sincronet], params[:municipio_sincronet], params[:parroquia_sincronet], params[:punto_referencia_sincronet], params[:codigo_postal_sincronet], params[:telefono1_sincronet], params[:telefono2_sincronet], params[:telefono3_sincronet], params[:fax_sincronet], params[:email_sincronet], "COMERCIO ELECTRONICO / SINCRONET")   
        # else
        #   Correspondencia.agregar_correspondencia(@empresa.prefijo, params[:persona_contacto_sincronet], params[:cargo_sincronet], params[:edificio_sincronet], params[:detalle_edificio_sincronet], params[:piso_sincronet], params[:detalle_piso_sincronet], params[:oficina_sincronet], params[:detalle_oficina_sincronet], params[:calle_sincronet], params[:detalle_calle_sincronet], params[:urbanizacion_sincronet], params[:detalle_urbanizacion_sincronet], params[:estado_sincronet], params[:ciudad_sincronet], params[:municipio_sincronet], params[:parroquia_sincronet], params[:punto_referencia_sincronet], params[:codigo_postal_sincronet], "COMERCIO ELECTRONICO / SINCRONET", params[:telefono1_sincronet], params[:telefono2_sincronet], params[:telefono3_sincronet], params[:fax_sincronet], params[:email_sincronet]) 
        # end

        # if (codificacionGS1)
        #   Correspondencia.modificar_correspondencia(@empresa.prefijo, params[:persona_contacto_codificacion], params[:cargo_codificacion], params[:edificio_codificacion], params[:detalle_edificio_codificacion], params[:piso_codificacion], params[:detalle_piso_codificacion], params[:oficina_codificacion], params[:detalle_oficina_codificacion], params[:calle_codificacion], params[:detalle_calle_codificacion], params[:urbanizacion_codificacion], params[:detalle_urbanizacion_codificacion], params[:estado_codificacion], params[:ciudad_codificacion], params[:municipio_codificacion], params[:parroquia_codificacion], params[:punto_referencia_codificacion], params[:codigo_postal_codificacion], params[:telefono1_codificacion], params[:telefono2_codificacion], params[:telefono3_codificacion], params[:fax_codificacion], params[:email_codificacion], "CODIFICACION GS1")   
        # else
        #   Correspondencia.agregar_correspondencia(@empresa.prefijo, params[:persona_contacto_codificacion], params[:cargo_codificacion], params[:edificio_codificacion], params[:detalle_edificio_codificacion], params[:piso_codificacion], params[:detalle_piso_codificacion], params[:oficina_codificacion], params[:detalle_oficina_codificacion], params[:calle_codificacion], params[:detalle_calle_codificacion], params[:urbanizacion_codificacion], params[:detalle_urbanizacion_codificacion], params[:estado_codificacion], params[:ciudad_codificacion], params[:municipio_codificacion], params[:parroquia_codificacion], params[:punto_referencia_codificacion], params[:codigo_postal_codificacion], "CODIFICACION GS1", params[:telefono1_codificacion], params[:telefono2_codificacion], params[:telefono3_codificacion], params[:fax_codificacion], params[:email_codificacion])  
        # end

        # if (seminarios)
        #   Correspondencia.modificar_correspondencia(@empresa.prefijo, params[:persona_contacto_seminario], params[:cargo_seminario], params[:edificio_seminario], params[:detalle_edificio_seminario], params[:piso_seminario], params[:detalle_piso_seminario], params[:oficina_seminario], params[:detalle_oficina_seminario], params[:calle_seminario], params[:detalle_calle_seminario], params[:urbanizacion_seminario], params[:detalle_urbanizacion_seminario], params[:estado_seminario], params[:ciudad_seminario], params[:municipio_seminario], params[:parroquia_seminario], params[:punto_referencia_seminario], params[:codigo_postal_seminario], params[:telefono1_seminario], params[:telefono2_seminario], params[:telefono3_seminario], params[:fax_seminario], params[:email_seminario], "SEMINARIOS / CURSOS")   
        # else
        #   Correspondencia.agregar_correspondencia(@empresa.prefijo, params[:persona_contacto_seminario], params[:cargo_seminario], params[:edificio_seminario], params[:detalle_edificio_seminario], params[:piso_seminario], params[:detalle_piso_seminario], params[:oficina_seminario], params[:detalle_oficina_seminario], params[:calle_seminario], params[:detalle_calle_seminario], params[:urbanizacion_seminario], params[:detalle_urbanizacion_seminario], params[:estado_seminario], params[:ciudad_seminario], params[:municipio_seminario], params[:parroquia_seminario], params[:punto_referencia_seminario], params[:codigo_postal_seminario], "SEMINARIOS / CURSOS", params[:telefono1_seminario], params[:telefono2_seminario], params[:telefono3_seminario], params[:fax_seminario], params[:email_seminario])  
        # end

        # if (mercadeo)
        #   Correspondencia.modificar_correspondencia(@empresa.prefijo, params[:persona_contacto_mercadeo], params[:cargo_mercadeo], params[:edificio_mercadeo], params[:detalle_edificio_mercadeo], params[:piso_mercadeo], params[:detalle_piso_mercadeo], params[:oficina_mercadeo], params[:detalle_oficina_mercadeo], params[:calle_mercadeo], params[:detalle_calle_mercadeo], params[:urbanizacion_mercadeo], params[:detalle_urbanizacion_mercadeo], params[:estado_mercadeo], params[:ciudad_mercadeo], params[:municipio_mercadeo], params[:parroquia_mercadeo], params[:punto_referencia_mercadeo], params[:codigo_postal_mercadeo], params[:telefono1_mercadeo], params[:telefono2_mercadeo], params[:telefono3_mercadeo], params[:fax_mercadeo], params[:email_mercadeo], "MERCADEO")    
        # else
        #   Correspondencia.agregar_correspondencia(@empresa.prefijo, params[:persona_contacto_mercadeo], params[:cargo_mercadeo], params[:edificio_mercadeo], params[:detalle_edificio_mercadeo], params[:piso_mercadeo], params[:detalle_piso_mercadeo], params[:oficina_mercadeo], params[:detalle_oficina_mercadeo], params[:calle_mercadeo], params[:detalle_calle_mercadeo], params[:urbanizacion_mercadeo], params[:detalle_urbanizacion_mercadeo], params[:estado_mercadeo], params[:ciudad_mercadeo], params[:municipio_mercadeo], params[:parroquia_mercadeo], params[:punto_referencia_mercadeo], params[:codigo_postal_mercadeo], "MERCADEO", params[:telefono1_mercadeo], params[:telefono2_mercadeo], params[:telefono3_mercadeo], params[:fax_mercadeo], params[:email_mercadeo])  
        # end

        

        format.html { 
          if session[:gerencia] == 'Estandares y Consultoría' or session[:perfil] == 'Administrador' or session[:perfil] == 'Super Usuario'

            redirect_to '/empresas', notice: "EMPRESA CON PREFIJO #{@empresa.prefijo} ACTUALIZADA SATISFACTORIAMENTE." 
          else
            redirect_to '/empresas?activacion=true', notice: "EMPRESA #{@empresa.nombre_empresa} ACTUALIZADA SATISFACTORIAMENTE." 
          end
        }

        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_multiple

   
    Empresa.validar_empresas(params[:activar_empresas]) if params[:activar_empresas] #Parametro que indica Validar Empresa       
    Empresa.retirar_empresas(params) if params[:retiro]
    Empresa.eliminar_empresas(params) if params[:eliminar]
    Empresa.reactivar_empresas_retiradas(params) if params[:reactivar]
    Empresa.cambiar_sub_estatus(params) if params[:sub_estatus]

    
    @procesadas = ""
    params[:activar_empresas].collect{|prefijo| @procesadas += prefijo + " " } if params[:activar_empresas]
    params[:retirar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:retirar_empresas]
    params[:eliminar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:eliminar_empresas]
    params[:reactivar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:reactivar_empresas]
    params[:sub_estatus_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:sub_estatus]

    respond_to do |format|
          format.html { 
          redirect_to '/empresas', notice: "PREFIJO #{@procesadas} ACTIVADO"  if params[:activar_empresas]
          redirect_to '/empresas?retiradas=true', notice: "Los Prefijos #{@procesadas} fueron retirados."  if params[:retiro]
          redirect_to '/empresas?eliminadas=true', notice: "Los Prefijos #{@procesadas} fueron eliminados."  if params[:eliminar_empresas]
          redirect_to '/empresas', notice: "Los Prefijos #{@procesadas} fueron reactivados satisfactoriamente." if params[:reactivar]  # Empresasa eliminadas que se reactivan
          redirect_to '/empresas', notice: "Los Prefijos #{@procesadas} fueron modificados sus sub estatus." if params[:sub_estatus]  
        }
    end
  end

  # DELETE /empresas/1
  # DELETE /empresas/1.json
  def destroy
    @empresa = Empresa.find(params[:id])
    @empresa.destroy

    respond_to do |format|
      format.html { redirect_to empresas_url }
      format.json { head :no_content }
    end
  end

end
