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
                    @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:estado, :ciudad, :estatus, :correspondencia, :clasificacion).order("empresa.fecha_inscripcion")
                    render "/empresas/activacion_empresas.xlsx.axlsx"
                  else
                    @empresas = Empresa.includes(:estado, :ciudad, :estatus, :tipo_usuario_empresa, :clasificacion).where("estatus.descripcion = ?", 'Activa').order("empresa.fecha_inscripcion desc")
                    render  "/empresas/index.xlsx.axlsx"
                  end 
      }
      
      format.csv{ 
        
                @empresas = @empresas.where("estatus.descripcion = ?", 'Activa') if params[:retirar]
                @empresas = @empresas.where("prefijo like :search", search: "%#{params[:prefijo]}%") if (params[:prefijo] != '')
                @empresas = @empresas.where("nombre_empresa like :search", search: "%#{params[:nombre_empresa]}%") if (params[:nombre_empresa] != '')
                @empresas = @empresas.where("fecha_inscripcion like :search", search: "%#{params[:fecha_inscripcion]}%") if (params[:fecha_inscripcion] != '')
                @empresas = @empresas.where("estados.nombre like :search", search: "%#{params[:estado]}%") if (params[:estado] != '')
                @empresas = @empresas.where("ciudad.nombre like :search", search: "%#{params[:ciudad]}%") if (params[:ciudad] != '')
                @empresas = @empresas.where("empresa.rif like :search", search: "%#{params[:rif]}%")  if (params[:rif] != '')
                @empresas = @empresas.where("estatus.descripcion like :search", search: "%#{params[:estatus]}%")  if (params[:estatus] != '')
                send_data @empresas.to_csv
      }

      format.pdf {

                if (params[:retiradas])
                  @empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, {:empresas_retiradas => :sub_estatus},{:empresas_retiradas => :motivo_retiro}).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("empresas_retiradas.fecha_retiro desc")
                  render "/empresas/empresas_retiradas.pdf.prawn"
                elsif params[:eliminadas]
                  @empresas = EmpresaEliminada.where("estatus.descripcion = ?", 'Eliminada').includes(:estado, :ciudad, :estatus, :clasificacion, :empresa_elim_detalle, :sub_estatus, :motivo_retiro).order("empresa_elim_detalle.fecha_eliminacion desc")
                  render "/empresas/empresas_eliminadas.pdf.prawn"
                elsif params[:activacion]
                  @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:estado, :ciudad, :estatus).order("empresa.fecha_inscripcion")
                  render "/empresas/activacion_empresas.pdf.prawn"
                else
                  @empresas = Empresa.includes(:estado, :ciudad, :estatus, :tipo_usuario_empresa, :clasificacion).where("estatus.descripcion = ?", 'Activa').order("empresa.fecha_inscripcion desc")
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
    @correspondencia = (params[:eliminados]) ? @empresa.correspondencia_eliminada : @empresa.correspondencia
    
    #@empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:id]])
    

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
    @empresa.build_correspondencia   #Para que maneje el modelo de correspondencia
    @empresa.datos_contacto.build   #Para que manejar los datos de la tabla empresa_contactos, mapeado por el modelo DatosContacto
    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @empresa }
    end
  end

  # GET /empresas/1/edit
  def edit
    @empresa = Empresa.find(params[:id])
    @empresa.build_correspondencia  if @empresa.correspondencia.nil? # Si no tiene coorespondecia se crea el objeto
    @datos_contactos = (params[:eliminados]) ? @empresa.empresa_contacto_eliminada : @empresa.datos_contacto

  end

  # POST /empresas
  # POST /empresas.json
  def create

    @ultimo =  Empresa.generar_prefijo_valido
    params[:empresa][:id_estatus] = Estatus.empresa_inactiva()
    # Se completa la hora con los segundos para que pueda ordenar por la ultima creada
    time = Time.now
    params[:empresa][:fecha_inscripcion] +=  " " + time.hour.to_s + ":" + time.min.to_s + ":" + time.sec.to_s  if params[:empresa][:fecha_inscripcion] != ''
    @empresa = Empresa.new(params[:empresa])

    params[:empresa][:id_tipo_usuario] = 3 if params[:empresa][:id_tipo_usuario] == '' # Si el usaurio no especifico el tipo de empresa

    respond_to do |format|
     
     if @empresa.save

        Empresa.agregar_contacto(params[:telefono2], @empresa.prefijo, "telefono") if params[:telefono2]
        Empresa.agregar_contacto(params[:telefono3], @empresa.prefijo, "telefono") if params[:telefono3]
        Empresa.agregar_contacto(params[:fax], @empresa.prefijo, "telefono") if params[:fax]
        Empresa.agregar_contacto(params[:email], @empresa.prefijo, "email") if params[:email]
        
        Gln.generar_legal(@empresa.prefijo.to_s) # Se genra GLN legal

        Auditoria.registrar_evento(session[:user_id],"Empresa", "Crear", Time.now, "Prefijo #{@empresa.prefijo}")
        format.html { redirect_to '/empresas?activacion=true', notice: "Empresa creada satisfactoriamente. Prefijo:#{@empresa.prefijo}   Nombre:#{@empresa.nombre_empresa}" }

      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /empresas/1
  # PUT /empresas/1.json
  def update


    @empresa = Empresa.find(params[:id])
    @datos_contactos = (params[:eliminados]) ? @empresa.empresa_contacto_eliminada : @empresa.datos_contacto

    respond_to do |format|
      if @empresa.update_attributes(params[:empresa])
        format.html { redirect_to '/empresas', notice: "Empresa con prefijo #{@empresa.prefijo} actualizada satisfactoriamente." }
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
     
    
    @procesadas = ""
    params[:activar_empresas].collect{|prefijo| @procesadas += prefijo + " " } if params[:activar_empresas]
    params[:retirar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:retirar_empresas]
    params[:eliminar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:eliminar_empresas]
    params[:reactivar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:reactivar_empresas]

    respond_to do |format|
          format.html { 
          redirect_to '/empresas', notice: "Los Prefijos #{@procesadas} fueron activados."  if params[:activar_empresas]
          redirect_to '/empresas?retiradas=true', notice: "Los Prefijos #{@procesadas} fueron retirados."  if params[:retiro]
          redirect_to '/empresas?eliminadas=true', notice: "Los Prefijos #{@procesadas} fueron eliminados."  if params[:eliminar_empresas]
          redirect_to '/empresas', notice: "Los Prefijos #{@procesadas} fueron reactivados satisfactoriamente." if params[:reactivar]  # Empresasa eliminadas que se reactivan
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
