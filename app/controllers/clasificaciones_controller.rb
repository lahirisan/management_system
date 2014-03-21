class ClasificacionesController < ApplicationController
  # GET /clasificaciones/1
  # GET /clasificaciones/1.json
  def show
    @clasificacion = Clasificacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clasificacion }
    end
  end
end
