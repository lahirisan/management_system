class GlnsController < ApplicationController
  # GET /glns
  # GET /glns.json
  def index
    
    respond_to do |format|
      format.html {
        if params[:eliminar]
          render :template => '/glns/eliminar_gln.html.haml'
        elsif params[:eliminados]
          render :template => '/glns/gln_eliminados.html.haml'
        else
          render :template => '/glns/index.html.haml'
        end
      }

      format.json { 

        if params[:eliminar]
          render json: (EliminarGlnDatatable.new(view_context))
        elsif params[:eliminados]
          render json: (GlnEliminadosDatatable.new(view_context))
        else
          render json: GlnsDatatable.new(view_context)
        end
      }
    end
  end

  # GET /glns/1
  # GET /glns/1.json
  def show
    @gln = Gln.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gln }
    end
  end

  # GET /glns/new
  # GET /glns/new.json
  def new

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
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
    @gln = Gln.new(params[:gln])

    respond_to do |format|
      if @gln.save
        format.html { redirect_to @gln, notice: 'Gln was successfully created.' }
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
    gln_eliminados = ""
    params[:eliminar_gln].collect{|gln| gln_eliminados += gln + " "}

    respond_to do |format|
      format.html { redirect_to   "#{empresa_glns_path}?eliminado=true", notice: "GLN Eliminado(s): #{gln_eliminados}"}
      format.json { head :no_content }
    end
  end


end
