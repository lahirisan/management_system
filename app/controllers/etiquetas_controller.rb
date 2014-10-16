class EtiquetasController < ApplicationController
  
  before_filter :require_authentication
  prawnto :prawn => { :top_margin => 10, :left_margin => 10, :page_layout => :portrait, :page_size => [279, 200]} 
  
  def show

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:id]])

    @ciudad_ean = Ciudad.find(@empresa.id_ciudad_ean) if @empresa.id_ciudad_ean
    @municipio_ean = Municipio.find(@empresa.id_municipio_ean) if @empresa.id_municipio_ean
    @estado_ean = Estado.find(@empresa.id_estado_ean) if @empresa.id_estado_ean

    @navegabilidad = @empresa.try(:prefijo).to_s+" > "+@empresa.try(:nombre_empresa) + " > Etiqueta"
    
    respond_to do |format|
      format.html # show.html.haml
      format.pdf{}

    end

  end

  # GET /empresa/:empresa_id/correspondencia/:id_correspondencia/edit
  def edit

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @etiqueta = Correspondencia.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @contacto = DatosContacto.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])

  end


  def update

    Correspondencia.modificar_etiqueta(params)
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])

    respond_to do |format|
        
      format.html { redirect_to empresa_etiqueta_path, notice: "Los datos para la etiqueta de la empresa #{@empresa.nombre_empresa} fueron modificados."}
     
    end
  end

end
