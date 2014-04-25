class EmpresaServiciosController < ApplicationController
  # GET /empresa_servicios
  # GET /empresa_servicios.json
  def index
    
    respond_to do |format|
      format.html # index.html.erb
       format.json {

        render json: (EmpresaServiciosDatatable.new(view_context)) }
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
    
    @empresa_servicio = EmpresaServicio.new
    @servicio = Servicio.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @empresa_servicio }
    end
  end

  # GET /empresa_servicios/1/edit
  def edit
    
    @empresa_servicio = EmpresaServicio.find(params[:id])
    @servicio = Servicio.find(@empresa_servicio.id_servicio)

  end

  # POST /empresa_servicios
  # POST /empresa_servicios.json
  def create

    @servicio = Servicio.new(params[:servicio])
    respond_to do |format|
      if @servicio.save
        
        params[:empresa_servicio][:id_servicio] = @servicio.id
        @empresa_servicio = EmpresaServicio.new(params[:empresa_servicio])
        @empresa_servicio.save
        format.html { redirect_to "/empresas/#{params[:empresa_servicio][:prefijo]}/empresa_servicios", notice: "El servicio #{params[:servicio][:nombre]} fue creado para la empresa con prefijo #{params[:empresa_servicio][:prefijo]}"}
        
      else
        format.html { render action: "new" }
        format.json { render json: @empresa_servicio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /empresa_servicios/1
  # PUT /empresa_servicios/1.json
  def update
    
    @empresa_servicio = EmpresaServicio.find(params[:id])
    @servicio = Servicio.find(@empresa_servicio.id_servicio)

    respond_to do |format|
      if @empresa_servicio.update_attributes(params[:empresa_servicio])
         @servicio.update_attributes(params[:servicio])

        format.html { redirect_to "/empresas/#{params[:empresa_servicio][:prefijo]}/empresa_servicios", notice: "EL servicio #{params[:servicio][:nombre]} fue actualizado para la empresa con prefijo #{params[:empresa_servicio][:prefijo]}"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @empresa_servicio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresa_servicios/1
  # DELETE /empresa_servicios/1.json
  def destroy
    @empresa_servicio = EmpresaServicio.find(params[:id])
    @empresa_servicio.destroy

    respond_to do |format|
      format.html { redirect_to empresa_servicios_url }
      format.json { head :no_content }
    end
  end
end
