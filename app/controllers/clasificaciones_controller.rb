class ClasificacionesController < ApplicationController
  # GET /clasificaciones/1
  # GET /clasificaciones/1.json
  def index

  	
  	respond_to do |format|
      format.html # show.html.erb
      format.json { 

        @clasificacion = Clasificacion.find(:first, :conditions => ["division = ? and categoria = ? and grupo = ? and clase = ?", params[:division].strip, params[:categoria].strip, params[:grupo].strip, params[:clase].strip])
        render json: @clasificacion 
      }
      
    end


  end

  def show
    @clasificacion = Clasificacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clasificacion }
    end
  end
end
