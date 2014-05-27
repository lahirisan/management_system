class EtiquetasController < ApplicationController
  
  before_filter :require_authentication
  
  # GET /empresas/:empresa_id/correspondencia
  # GET /empresas/:empresa_id/correspondencia.json
  def index

    respond_to do |format|
      format.html 
      format.json {
      }
    end
  end

  # GET /glns/1
  # GET /glns/1.json
  def show

  	@etiqueta = Correspondencia.find(:first, :conditions => ["prefijo = ?", params[:id]], :include => :empresa)
    @contacto = DatosContacto.find(:first, :conditions => ["prefijo = ? and tipo = ?", params[:empresa_id], 'principal'])


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gln }
    end
  end

  # GET /glns/new
  # GET /glns/new.json
  def new

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    # SI la empresa GLN Legal puede crear GLN fisico y operativo, sino puede crear legal
    
    @gln = @empresa.gln.build


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gln }
    end
  end

  # GET /glns/1/edit
  
  def edit

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @etiqueta = Correspondencia.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @contacto = DatosContacto.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])

  end

  # POST /glns
  # POST /glns.json
  def create
    
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]]) # para la validacion del formulario

    params[:gln][:gln] = Gln.generar(params[:empresa_id])
    params[:gln][:fecha_asignacion] = Time.now
    estatus = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Activo', 'GLN'])
    params[:gln][:id_estatus] = estatus.id
    params[:gln][:codigo_localizacion] = Gln.codigo_localizacion(@empresa.prefijo)
    @gln = Gln.new(params[:gln])

    respond_to do |format|
      if @gln.save
        format.html { redirect_to empresa_glns_path, notice: "GLN #{@gln.gln} fue generado."}
        format.json { render json: @gln, status: :created, location: @gln }
      else
        format.html { render action: "new" }
        format.json { render json: @gln.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /glns/1
  # PUT /glns/1.json
  def update

    @gln = Gln.find(params[:id])
    respond_to do |format|
      if @gln.update_attributes(params[:gln])
        format.html { redirect_to empresa_glns_path, notice: "EL GLN fue modificado correctamente." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gln.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy_multiple

    Gln.eliminar(params)
    gln = ""
    params[:eliminar_glns].collect{|gln_| gln += gln_ + " "} if params[:eliminar_glns]

    respond_to do |format|
      format.html { redirect_to "#{empresa_glns_path}?eliminados=true", notice: "GLN Eliminado(s): #{gln}"}
      format.json { head :no_content }
    end
  end
end
