class EmpresasController < ApplicationController
  # GET /empresas
  # GET /empresas.json
  def index
    @empresas = Empresa.includes(:estado, :ciudad, :estatus)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: EmpresasDatatable.new(view_context) }
      format.xlsx{ # render index.xlsx.alxsx 
       }
      format.csv{ send_data @empresas.to_csv}
      format.pdf {}  # Generar PDF

    end

  end

  # GET /empresas/1
  # GET /empresas/1.json
  def show
    @empresa = Empresa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @empresa }
    end
  end

  # GET /empresas/new
  # GET /empresas/new.json
  def new

    @ultimo = Empresa.find(:first, :conditions => ["prefijo < 999999999"], :order => "prefijo DESC") # EL ultimo prefijo antes de 999999999
    @empresa = Empresa.new
    @empresa.build_correspondencia   #Para que maneje el model de correspondencia
    @tipo_usuario = Usuario.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @empresa }
    end
  end

  # GET /empresas/1/edit
  def edit
    @empresa = Empresa.find(params[:id])
    @empresa.build_correspondencia  if @empresa.correspondencia.nil? # Si no tiene coorespondecia se crea el objeto
    
  end

  # POST /empresas
  # POST /empresas.json
  def create

    @ultimo = Empresa.find(:first, :conditions => ["prefijo < 999999999"], :order => "prefijo DESC")
    @empresa = Empresa.new(params[:empresa])
    @empresa.id_estatus = 5 # Cuado se crea una empresa su estatas en No Validada estatus.id = 5
    
    respond_to do |format|

      if @empresa.save
          
        format.html { redirect_to '/empresas', notice: 'Empresa creada satisfactoriamente' }
        format.json { render json: @empresa, status: :created, location: @empresa }
      else
        format.html { render action: "new" }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /empresas/1
  # PUT /empresas/1.json
  def update
    @empresa = Empresa.find(params[:id])

    respond_to do |format|
      if @empresa.update_attributes(params[:empresa])
        format.html { redirect_to '/empresas', notice: 'Empresa editada satisfactoriamente' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /empresas/1
  # DELETE /empresas/1.json
  def destroy
    @empresa = Empresa.find(params[:id])
    @empresa.destroy

    respond_to do |format|
      format.html { redirect_to empresas_url }
      format.json { head :no_content }
    end
  end
end
