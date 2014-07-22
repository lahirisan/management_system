class EmpresaServiciosController < ApplicationController
  before_filter :require_authentication
  # GET /empresa_servicios
  # GET /empresa_servicios.json
  def index
    
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @empresa = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]]) if @empresa.nil?


    respond_to do |format|
      format.html {
                  if params[:eliminar]
                    @navegabilidad = @empresa.nombre_empresa + " > Eliminar Servicios"
                    render :template =>'/empresa_servicios/eliminar_empresa_servicios.html.haml'
                  elsif params[:eliminados]
                    @navegabilidad = @empresa.nombre_empresa + " > Servicios Eliminados"
                    render :template =>'/empresa_servicios/servicios_eliminados.html.haml'
                  else
                    @empresas_retiradas = params[:retirados].nil? ? false : true
                    @navegabilidad = @empresa.nombre_empresa + " > Servicios Activos > Listado"
                    render :template =>'/empresa_servicios/index.html.haml'
                  end
                   
      }
       format.json {
                    if params[:eliminar]
                      render json: (EliminarEmpresaServiciosDatatable.new(view_context))
                    elsif params[:eliminados]
                      render json: (EmpresaServiciosEliminadosDatatable.new(view_context))
                    else
                      render json: (EmpresaServiciosDatatable.new(view_context)) 
                    end
                    
                  }

      format.pdf{
                  if params[:eliminar]
                    @empresa_servicios = EmpresaServicio.where("empresa_servicios.prefijo = ?", params[:empresa_id]).includes(:servicio, :empresa).order("empresa_servicios.fecha_contratacion") 
                    render '/empresa_servicios/eliminar_servicio.pdf.prawn'
                  elsif params[:eliminados]
                    @empresa_servicios = EmpresaServiciosEliminado.where("prefijo = ?", params[:empresa_id]).includes(:servicio, :sub_estatus, :motivo_retiro).order("empresa_servicios_eliminado.fecha_eliminacion") 
                    render :template =>'/empresa_servicios/servicios_eliminados.pdf.prawn'
                  else
                    @empresa_servicios = EmpresaServicio.where("empresa_servicios.prefijo = ?", params[:empresa_id]).includes(:servicio, :empresa).order("empresa_servicios.fecha_contratacion") 
                    render '/empresa_servicios/index.pdf.prawn'
                  end
      }

      format.xlsx{
                  if params[:eliminar]
                    @empresa_servicios = EmpresaServicio.where("empresa_servicios.prefijo = ?", params[:empresa_id]).includes(:servicio, :empresa).order("empresa_servicios.fecha_contratacion") 
                    render '/empresa_servicios/index.xlsx.axlsx'
                  elsif params[:eliminados]
                     @empresa_servicios = EmpresaServiciosEliminado.where("prefijo = ?", params[:empresa_id]).includes(:servicio, :sub_estatus, :motivo_retiro).order("empresa_servicios_eliminado.fecha_eliminacion") 
                    render '/empresa_servicios/servicios_eliminados.xlsx.axlsx'
                  else
                    @empresa_servicios = EmpresaServicio.where("empresa_servicios.prefijo = ?", params[:empresa_id]).includes(:servicio, :empresa).order("empresa_servicios.fecha_contratacion") 
                    render '/empresa_servicios/index.xlsx.axlsx'
                  end
      }
    end
  end

  # GET /empresa_servicios/1
  # GET /empresa_servicios/1.json
  def show
    @empresa_servicio = EmpresaServicio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @empresa_servicio }
    end
  end

  # GET /empresa_servicios/new
  # GET /empresa_servicios/new.json
  def new
    
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @empresa_servicio = @empresa.empresa_servicio.build

    
    respond_to do |format|
      format.html # new.html.erb
      
    end
  end

  # GET /empresa_servicios/1/edit
  def edit
    
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @empresa_servicio = EmpresaServicio.find(params[:id])
    
  end

  # POST /empresa_servicios
  # POST /empresa_servicios.json
  def create
    
    params[:empresa_servicio][:prefijo] = params[:empresa_id]
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @empresa_servicio = @empresa.empresa_servicio.build(params[:empresa_servicio])

    respond_to do |format|
      if @empresa_servicio.save
        
        format.html { redirect_to empresa_empresa_servicios_path, notice: "El servicio #{@empresa_servicio.servicio.nombre} fue asociado a la empresa #{@empresa_servicio.empresa.nombre_empresa}"}
        
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /empresa_servicios/1
  # PUT /empresa_servicios/1.json
  def update

    @empresa_servicio = EmpresaServicio.find(params[:id])
    respond_to do |format|
      if @empresa_servicio.update_attributes(params[:empresa_servicio])

        format.html { redirect_to empresa_empresa_servicios_path, notice: "Los datos del servicio fueron actualizados para la empresa #{@empresa_servicio.empresa.nombre_empresa}"}
      
      else
        format.html { render action: "edit" }
        format.json { render json: @empresa_servicio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresa_servicios/1
  # DELETE /empresa_servicios/1.json
  def destroy

    # Los nombre de los servicios
    servicios = ""
    params[:eliminar_servicios].collect{|id_servicio| empresa_servicio = EmpresaServicio.find(id_servicio); servicios += empresa_servicio.servicio.nombre +  " "}
    
    EmpresaServicio.eliminar(params) if params[:eliminar]
    respond_to do |format|
      format.html { redirect_to "/empresas/#{params[:empresa_id]}/empresa_servicios?eliminados=true", notice: "Los servicios #{servicios} fueron eliminados."}
    end
  end
end
