class EtiquetasController < ApplicationController
  
  before_filter :require_authentication
  
  def show

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:id]])
    @estado_ean = Estado.find(@empresa.id_estado_ean)
    @ciudad_ean = Ciudad.find(@empresa.id_ciudad_ean) 

    @municipio_ean = Municipio.find(@empresa.id_municipio_ean)

    @telefono =  Empresa.telefono1_ean(@empresa.prefijo)
    @telefono += " / #{Empresa.telefono2_ean(@empresa.prefijo)}" if Empresa.telefono2_ean(@empresa)

    
    @navegabilidad = @empresa.try(:prefijo).to_s+" > "+@empresa.try(:nombre_empresa) + " > Etiqueta"
    
    respond_to do |format|
      format.html # show.html.haml
      format.pdf{
        pdf = EtiquetaPdf.new(@empresa)
        send_data pdf.render
      }

    end

  end

  # GET /empresa/:empresa_id/correspondencia/:id_correspondencia/edit
  def edit

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    
  end


  def update

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])


    respond_to do |format|

       if @empresa.update_attributes(params[:empresa])
        format.html { redirect_to empresa_etiqueta_path, notice: "Los datos para la etiqueta de la empresa #{@empresa.nombre_empresa} fueron modificados."}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        
      end
        
      
     
    end
  end

end
