class GlnsController < ApplicationController
  before_filter :require_authentication
  # GET /glns
  # GET /glns.json
  def index

    
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    
    @empresa =  EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]]) if @empresa.nil?
    
    respond_to do |format|
      format.html {
        if params[:eliminar]
          @navegabilidad = @empresa.nombre_empresa + " > Eliminar GLN"
          render :template => '/glns/eliminar_gln.html.haml'
        elsif params[:eliminados]
          @navegabilidad = @empresa.nombre_empresa + " > GLN Eliminados"
          render :template => '/glns/gln_eliminados.html.haml'
        else
          @empresas_retiradas = params[:retirados].nil? ? false : true
          @navegabilidad = @empresa.nombre_empresa + " > GLN > Listado"
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
      format.pdf{

       if params[:eliminar]
          @glns = GlnEmpresa.where("gln_empresa.prefijo = ? and tipo_gln.id in (?)", params[:empresa_id], [2,3]).joins({:gln => :tipo_gln}, {:gln => :estado}, {:gln => :municipio}, {:gln => :ciudad}, {:gln => :estatus},  :empresa).order("gln.fecha_asignacion")  
          render '/glns/eliminar.pdf.prawn'
        elsif params[:eliminados]
          render :template => '/glns/gln_eliminados.html.haml'
        else
          @glns = GlnEmpresa.where("gln_empresa.prefijo = ?", params[:empresa_id]).joins({:gln => :tipo_gln} , {:gln => :estatus}, {:gln => :estado}, {:gln => :municipio}, {:gln => :ciudad},  :empresa).order("gln.fecha_asignacion") 
          render '/glns/index.pdf.prawn'
        end 
      }
      format.xlsx {
        if params[:eliminar]
          @glns = GlnEmpresa.where("gln_empresa.prefijo = ? and tipo_gln.id in (?)", params[:empresa_id], [2,3]).joins({:gln => :tipo_gln}, {:gln => :estado}, {:gln => :municipio}, {:gln => :ciudad}, {:gln => :estatus},  :empresa).order("gln.fecha_asignacion")  
          render '/glns/eliminar.xlsx.axlsx'
        elsif params[:eliminados]
          render :template => '/glns/gln_eliminados.html.haml'
        else
          @glns = GlnEmpresa.where("gln_empresa.prefijo = ?", params[:empresa_id]).joins({:gln => :tipo_gln} , {:gln => :estatus}, {:gln => :estado}, {:gln => :municipio}, {:gln => :ciudad},  :empresa).order("gln.fecha_asignacion") 
          render '/glns/index.xlsx.axlsx'
        end 

      }
    end
  end

  # GET /glns/1
  # GET /glns/1.json
  def show

    @gln =  params[:eliminado] ? GlnEliminado.find(params[:id]) : Gln.find(params[:id])

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
    
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]]) # para la validacion del formulario

    params[:gln][:gln] = Gln.generar(params[:empresa_id])
    params[:gln][:fecha_asignacion] = Time.now
    estatus = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Activo', 'GLN'])
    params[:gln][:id_estatus] = estatus.id
    params[:gln][:codigo_localizacion] = params[:gln][:gln][7..11]
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
