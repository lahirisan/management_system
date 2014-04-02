class EmpresasController < ApplicationController
  # GET /empresas
  # GET /empresas.json
  def index
    @empresas = Empresa.includes(:estado, :ciudad, :estatus)
    
    # OJO: La llamada JSON y los parametro se establecen en el datatable desde el template.html.haml
      
    respond_to do |format|
      format.html{       
        
                  if params[:activacion]
                    render :template =>'/empresas/activacion.html.haml' 
                  elsif params[:retirar]
                    render :template =>'/empresas/retirar_empresa.html.haml'
                  elsif params[:eliminar]
                    render :template =>'/empresas/eliminar_empresa.html.haml'
                  elsif params[:eliminadas]
                    render :template =>'/empresas/empresas_eliminadas.html.haml'  
                  else
                    render :template =>'/empresas/index.html.haml'
                  end

      } # index.html.erb
      
      format.json { 
                    if (params[:activacion] == 'true')
                      render json: (ActivacionEmpresasDatatable.new(view_context))
                    elsif (params[:retirar] == 'true')
                      render json: (RetirarEmpresasDatatable.new(view_context))
                    elsif (params[:eliminar] == 'true')
                      render json: (EliminarEmpresasDatatable.new(view_context))
                    elsif (params[:eliminadas] == 'true')
                      render json: (EmpresasEliminadasDatatable.new(view_context))
                    else
                      render json: (EmpresasDatatable.new(view_context))
                    end
                  }

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
    @empresa.build_correspondencia   #Para que maneje el modelo de correspondencia
    

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
    hora = Time.now # Para fijar la hora en que se crea la empresa
    params[:empresa][:fecha_inscripcion] += " #{hora.hour}:#{hora.min}:#{hora.sec}"
    @empresa = Empresa.new(params[:empresa])

    @empresa.id_estatus = 6 # Cuado se crea una empresa su estatas en No Validada estatus.id = 5
    
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

  def update_multiple

    Empresa.validar_empresas(params[:activar_empresa]) if params[:activacion] #Parametro que indica Validar Empresa       
    
    if params[:retiro]
      if params[:retiro_masivo] # vienen los 2 parametros
        Empresa.retirar_empresas_masivo(params) 
      else # solo el parametro retirar
        Empresa.retirar_empresas(params)
      end
    end

    if params[:eliminar]
      if params[:eliminar_masivo] # eliminar masivo
        Empresa.eliminar_empresas_masivo(params)
      else
        Empresa.eliminar_empresas(params) # eliminar los seleccionados
      end
    end

    respond_to do |format|
          format.html { 
          redirect_to '/empresas?activacion=true', notice: "Los Prefijos #{params[:activar_empresa].collect{|prefijo| prefijo}} fueron activados satisfactoriamente"  if params[:activacion]
          redirect_to '/empresas?retirar=true', notice: "Los Prefijos #{params[:retirar_empresas].collect{|prefijo| prefijo}} fueron activados satisfactoriamente"  if params[:retiro]
          redirect_to '/empresas?eliminar=true', notice: "Los Prefijos #{params[:eliminar_empresas].collect{|prefijo| prefijo}} fueron activados satisfactoriamente"  if params[:eliminar]
          }
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
