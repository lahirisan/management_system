class GlnsController < ApplicationController
  before_filter :require_authentication
  # GET /glns
  # GET /glns.json
  def index

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    
    respond_to do |format|
      format.html {
        if params[:eliminar]
          @navegabilidad = "#{@empresa.prefijo} > "+@empresa.nombre_empresa + " > Eliminar GLN"
          render :template => '/glns/eliminar_gln.html.haml'
       
        else
          @empresas_retiradas = params[:retirados].nil? ? false : true
          @navegabilidad = "#{@empresa.prefijo} > "+@empresa.nombre_empresa + " > GLN > Listado"
          # para mostrar el estatus de los GLN como retirados si la empresa esta retirada
          @ruta = (params[:empresa_retirada]) ? "/empresas/#{params[:empresa_id]}/glns.json?empresa_retirada=true" : "/empresas/#{params[:empresa_id]}/glns.json"  
          render :template => '/glns/index.html.haml'
        end
      }

      format.json { 

        if params[:eliminar]
          render json: (EliminarGlnDatatable.new(view_context))
       
        else
          render json: GlnsDatatable.new(view_context)
        end
      }
     
      
      format.xlsx {

        @glns = Gln.find(:all, :conditions => ["prefijo = ?", params[:empresa_id]], :include => [:tipo_gln, :estatus], :order => "fecha_asignacion")
        

        if params[:eliminar]
          render '/glns/eliminar.xlsx.axlsx'
        else
          render '/glns/index.xlsx.axlsx'
        end 

      }
      
    end
  end

  # GET /glns/1
  # GET /glns/1.json
  def show

    @gln = Gln.find(params[:id])
    @estatus = params[:retirado] ? "Retirado" : "Activo"

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
    @gln = Gln.find(params[:id])
  end

  # POST /glns
  # POST /glns.json
  def create
    
    estado = Estado.find(params[:gln][:estado])
    params[:gln][:estado] = estado.nombre
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]]) # para la validacion del formulario

    params[:gln][:gln] = Gln.generar(params[:empresa_id])
    params[:gln][:fecha_asignacion] = Time.now
    estatus = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Activo', 'GLN'])
    params[:gln][:id_estatus] = estatus.id
    params[:gln][:codigo_localizacion] = params[:gln][:gln][7..11]
    params[:gln][:prefijo] = params[:empresa_id]
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
      format.html { redirect_to "#{empresa_glns_path}", notice: "GLN Eliminado(s): #{gln}"}
      format.json { head :no_content }
    end
  end


end
