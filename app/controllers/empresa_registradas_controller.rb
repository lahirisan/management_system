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
          render :template => '/empresa_registradas/index.html.haml'
        end 
      }

      format.json {
        
        if params[:activar_solvencia]

          render json: (EmpresaRegistradasActivarSolvenciaDatatable.new(view_context)) 
        else
          render json: (EmpresaRegistradasDatatable.new(view_context)) 
        end

      }

    end
  end

  # GET /empresa_registradas/1
  # GET /empresa_registradas/1.json
  def show
    @empresa_registrada = EmpresaRegistrada.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @empresa_registrada }
    end
  end

  # GET /empresa_registradas/new
  # GET /empresa_registradas/new.json
  def new
    @empresa_registrada = EmpresaRegistrada.new
    @opciones = ['J', 'G', 'E', 'V']
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @empresa_registrada }
    end
  end

  # GET /empresa_registradas/1/edit
  def edit

    @empresa_registrada = EmpresaRegistrada.find(params[:id])
    @opciones = ['J', 'G', 'E', 'V']

    if (session[:perfil] == 'Super Usuario' and session[:gerencia] == 'Estandares y Consultoría') or (session[:perfil] == 'Administrador' and session[:gerencia] == 'Estandares y Consultoría')
      
      @prefijo = Empresa.generar_prefijo_valido

      @clasificacion_empresa = Clasificacion.find(:first, :conditions => ["categoria = ? and division = ? and grupo = ? and clase = ?", @empresa_registrada.categoria, @empresa_registrada.division, @empresa_registrada.grupo, @empresa_registrada.clase])
      @prefijos_disponibles = EmpresaEliminada.find(:all, :include => [:estatus], :conditions => ["(categoria = ? or division = ? or grupo = ? or clase = ?) and no_elejible is ? and prefijo >= 7590000 and prefijo <= 7599999", @empresa_registrada.categoria, @empresa_registrada.division, @empresa_registrada.grupo, @empresa_registrada.clase, nil], :select => "empresa.prefijo, empresa.nombre_empresa, clasificacion.descripcion, estatus.descripcion")

    end


  end

  # POST /empresa_registradas
  # POST /empresa_registradas.json
  def create
    params[:empresa_registrada][:id_estatus] = 5 # NO VALIDADA (SIN PREFIJO)
    params[:empresa_registrada][:id_subestatus] = 2 # NO SOLVENTE
    params[:empresa_registrada][:fecha_inscripcion] = Time.now
    params[:empresa_registrada][:id_tipo_usuario] = 3 if params[:empresa_registrada][:id_tipo_usuario] == '' # Si el usaurio no especifico el tipo de empresa
    params[:empresa_registrada][:contacto_tlf1] =  params[:codigo_telefono1] + "-" + params[:empresa_registrada][:contacto_tlf1] if params[:codigo_telefono1] != ""
    params[:empresa_registrada][:contacto_tlf2] = params[:codigo_telefono2] + "-" + params[:empresa_registrada][:contacto_tlf2] if params[:codigo_telefono2] != ""
    params[:empresa_registrada][:contacto_tlf3] = params[:codigo_telefono3] + "-" + params[:empresa_registrada][:contacto_tlf3] if params[:codigo_telefono3] != ""
    params[:empresa_registrada][:contacto_fax] = params[:codigo_telefono4] + "-" + params[:empresa_registrada][:contacto_fax] if params[:codigo_telefono4] != ""
    params[:empresa_registrada][:rif_completo] = params[:empresa_registrada][:tipo_rif] + "-" + params[:empresa_registrada][:rif]

    @empresa_registrada = EmpresaRegistrada.new(params[:empresa_registrada])

    @opciones = ['J', 'G', 'E', 'V']

    respond_to do |format|
      if @empresa_registrada.save
        
        # Se registra el evento de quien creo la empresa
        Auditoria.registrar_evento(session[:usuario],"empresa_registradas", "Crear", Time.now, "Empresa:#{@empresa_registrada.nombre_empresa} RIF:#{@empresa_registrada.rif}")

        format.html { redirect_to "/empresa_registradas", notice: "Empresa:#{@empresa_registrada.nombre_empresa} RIF:#{@empresa_registrada.rif} registrada satisfactoriamente." }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /empresa_registradas/1
  # PUT /empresa_registradas/1.json
  def update
    

    @empresa_registrada = EmpresaRegistrada.find(params[:id])

    params[:empresa_registrada][:fecha_ultima_modificacion] = Time.now # Se registra la fecha en que se edita la empresa
    params[:empresa_registrada][:rif_completo] = params[:empresa_registrada][:tipo_rif] + "-" + params[:empresa_registrada][:rif]
    @opciones = ['J', 'G', 'E', 'V']

    respond_to do |format|
      if @empresa_registrada.update_attributes(params[:empresa_registrada])
        
        if ((session[:gerencia] == 'Estandares y Consultoría' )  or session[:perfil] == 'Administrador')  and params[:activacion]

          Empresa.activar(@empresa_registrada)
          Auditoria.registrar_evento(session[:usuario],"empresa", "Activar", Time.now,  "EMPRESA ACTIVADA. PREFIJO:#{@empresa_registrada.prefijo}")
          format.html { redirect_to "/empresas", notice: "EMPRESA ACTIVADA. PREFIJO:#{@empresa_registrada.prefijo} NOMBRE EMPRESA:#{@empresa_registrada.nombre_empresa} RIF:#{@empresa_registrada.rif}" }

        else

          Auditoria.registrar_evento(session[:usuario],"empresa_registradas", "Editar", Time.now, params[:empresa_registrada])
          format.html { redirect_to "/empresa_registradas", notice: "Los datos de la Empresa:#{@empresa_registrada.nombre_empresa} RIF:#{@empresa_registrada.rif} fueron actualizados satisfactoriamente." }

        end
        
          
    
      else
        format.html { render action: "edit" }
    
      end
    end
  end

  def update_multiple  ## Ruta para asignar SOLVENTE  a las nuevas empresas  
    
    nuevas_empresas = EmpresaRegistrada.find(params[:activar_solvencias])

    solvente = SubEstatus.find(:first, :conditions => ["descripcion = ?", "SOLVENTE"])

    nuevas_empresas.collect{|nueva_empresa| 
      nueva_empresa.id_subestatus = solvente.id; 
      nueva_empresa.save; 
      Auditoria.registrar_evento(session[:usuario],"empresa_registradas", "Asignar SOLVENTE", Time.now, "EMPRESA #{nueva_empresa.nombre_empresa}  RIF #{nueva_empresa.rif}")
    }

    respond_to do |format|
        
        # Se registra la persona que la nueva empresa como SOLVENTE

        format.html { redirect_to "/empresa_registradas", notice: "       Las empresas con RIF #{nuevas_empresas.collect{|nueva_empresa| nueva_empresa.rif} } fueron marcadas como SOLVENTES."}
    
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
