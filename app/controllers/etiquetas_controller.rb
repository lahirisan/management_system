class EtiquetasController < ApplicationController
  
  before_filter :require_authentication
  prawnto :prawn => {:page_layout => :portrait, :page_size => [310, 200]} 
  
  def show

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:id]])

    @telefono =  @empresa.telefono1_ean
    @telefono += " / #{@empresa.telefono2_ean}" if @empresa.telefono2_ean
    

    
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
