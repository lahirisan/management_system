class DatosContactosController < ApplicationController
  # GET /datos_contactos
  # GET /datos_contactos.json
  def index

    @datos_contactos = DatosContacto.find(:all, :conditions => ["prefijo =?", params[:id]])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @datos_contactos }
    end
  end

  # GET /datos_contactos/1
  # GET /datos_contactos/1.json
  def show
    @datos_contacto = DatosContacto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @datos_contacto }
    end
  end

  # GET /datos_contactos/new
  # GET /datos_contactos/new.json
  def new
    @datos_contacto = DatosContacto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @datos_contacto }
    end
  end

  # GET /datos_contactos/1/edit
  def edit
    @datos_contacto = DatosContacto.find(params[:id])
  end

  # POST /datos_contactos
  # POST /datos_contactos.json
  def create
    @datos_contacto = DatosContacto.new(params[:datos_contacto])

    respond_to do |format|
      if @datos_contacto.save
        format.html { redirect_to @datos_contacto, notice: 'Datos contacto was successfully created.' }
        format.json { render json: @datos_contacto, status: :created, location: @datos_contacto }
      else
        format.html { render action: "new" }
        format.json { render json: @datos_contacto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /datos_contactos/1
  # PUT /datos_contactos/1.json
  def update
    @datos_contacto = DatosContacto.find(params[:id])

    respond_to do |format|
      if @datos_contacto.update_attributes(params[:datos_contacto])
        format.html { redirect_to @datos_contacto, notice: 'Datos contacto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @datos_contacto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datos_contactos/1
  # DELETE /datos_contactos/1.json
  def destroy
    @datos_contacto = DatosContacto.find(params[:id])
    @datos_contacto.destroy

    respond_to do |format|
      format.html { redirect_to datos_contactos_url }
      format.json { head :no_content }
    end
  end
end
