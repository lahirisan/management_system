class EmpresasController < ApplicationController
  # GET /empresas
  # GET /empresas.json
  def index
    @empresas = Empresa.includes(:estado, :ciudad, :estatus).limit(100)
    

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
                  elsif params[:retiradas]
                    render :template =>'/empresas/empresas_retiradas.html.haml'  
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
                    elsif (params[:retiradas] == 'true')
                      render json: (EmpresasRetiradasDatatable.new(view_context))
                    else
                      render json: (EmpresasDatatable.new(view_context))
                    end
                  }

      format.xlsx{ 
        raise params.to_yaml
       }
      
      format.csv{ send_data @empresas.to_csv}
      format.pdf { }  # Generar PDF

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

    @ultimo = Empresa.find(:first, :conditions => ["prefijo < 7600000"], :order => "prefijo DESC") # EL ultimo prefijo antes de 999999999
    @empresa = Empresa.new
    @empresa.build_correspondencia   #Para que maneje el modelo de correspondencia
    @empresa.datos_contacto.build   #Para que manejar los datos de la tabla empresa_contactos, mapeado por el modelo DatosContacto
    

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

    @ultimo = Empresa.find(:first, :conditions => ["prefijo < 7600000"], :order => "prefijo DESC")
    params[:empresa][:id_estatus] = Estatus.empresa_inactiva()
    @empresa = Empresa.new(params[:empresa])

    respond_to do |format|

      if @empresa.save
          
        format.html { redirect_to '/empresas', notice: "Empresa con prefijo #{@empresa.prefijo} creada satisfactoriamente." }
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
        format.html { redirect_to '/empresas', notice: "Empresa con prefijo #{@empresa.prefijo} actualizada satisfactoriamente." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_multiple

    Empresa.validar_empresas(params[:activar_empresa]) if params[:activacion] #Parametro que indica Validar Empresa       
    Empresa.retirar_empresas(params) if params[:retiro]
    Empresa.eliminar_empresas(params) if params[:eliminar]
    
    if params[:reactivar]
      if params[:retiradas]
        Empresa.reactivar_empresas_retiradas(params) 
      else
        Empresa.reactivar_empresas_eliminadas(params) 
      end
    end
    
    @procesadas = ""
    params[:activar_empresas].collect{|prefijo| @procesadas += prefijo } if params[:activar_empresas]
    params[:retirar_empresas].collect{|prefijo| @procesadas += prefijo } if params[:retirar_empresas]
    params[:eliminar_empresas].collect{|prefijo| @procesadas += prefijo } if params[:eliminar_empresas]
    params[:reactivar_empresas].collect{|prefijo| @procesadas += prefijo } if params[:reactivar_empresas]

    respond_to do |format|
          format.html { 
          redirect_to '/empresas?activacion=true', notice: "Los Prefijos #{@procesadas} fueron activados."  if params[:activacion]
          redirect_to '/empresas?retiradas=true', notice: "Los Prefijos #{@procesadas} fueron retirados."  if params[:retiro]
          redirect_to '/empresas?eliminar=true', notice: "Los Prefijos #{@procesadas} fueron eliminados"  if params[:eliminar]
          if params[:reactivar]
            if params[:retiradas]
              redirect_to '/empresas?retiradas=true', notice: "Los Prefijos #{@procesadas} fueron activados satisfactoriamente"
            else
              redirect_to '/empresas?eliminadas=true', notice: "Los Prefijos #{@procesadas} fueron activados satisfactoriamente"
            end
          end 
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
