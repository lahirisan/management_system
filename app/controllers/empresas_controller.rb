#encoding: UTF-8

class EmpresasController < ApplicationController
  before_filter :require_authentication
  
  prawnto :prawn => { :top_margin => 10, :page_layout => :landscape} 
  
  # GET /empresas
  # GET /empresas.json
  
  def index

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
                    @empresas_retiradas = Empresa.find(:all, :conditions => ["estatus.descripcion = ? and estatus.alcance = ? ", "Retirada", "Empresa"], :include => [:estatus])

                    render :template =>'/empresas/empresas_retiradas.html.haml'
                  elsif params[:reactivar]
                    render :template =>'/empresas/empresas_reactivar.html.haml'
                  elsif params[:sub_estatus]
                    render :template =>'/empresas/sub_estatus.html.haml'
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
                    elsif (params[:reactivar] == 'true')
                      render json: (ReactivarEmpresasDatatable.new(view_context))
                    elsif (params[:sub_estatus] == 'true')
                      render json: (EmpresasSubEstatusDatatable.new(view_context))
                    else
                      render json: (EmpresasDatatable.new(view_context))
                    end
                  }

      format.xlsx{

                  if params[:retiradas]

                    @empresas = Empresa.includes(:estado, :ciudad, :estatus, :motivo_retiro).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("fecha_retiro desc")  
                    
                    render  "/empresas/empresas_retiradas.xlsx.axlsx"

                  elsif params[:eliminadas]
                    @empresas = EmpresaEliminada.includes(:estado, :ciudad, :estatus, :clasificacion, :empresa_elim_detalle, :sub_estatus, :motivo_retiro).order("empresa_elim_detalle.fecha_eliminacion desc")
                    render "/empresas/empresas_eliminadas.xlsx.axlsx"
                  elsif params[:activacion]
                    @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:ciudad, :estatus, :tipo_usuario_empresa, :clasificacion).order("empresa.fecha_inscripcion")
                    render "/empresas/activacion_empresas.xlsx.axlsx"
                  else
                   
                    @empresas = Empresa.where("estatus.descripcion = ?", 'Activa').joins("inner join ciudad on empresa.id_ciudad = ciudad.id inner join estatus on empresa.id_estatus = estatus.id LEFT OUTER JOIN [BDGS1DTS.MDF].dbo.fnc_CltSlv () ON empresa.prefijo = [BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo").order("empresa.fecha_activacion desc").select("empresa.prefijo as prefijo, empresa.nombre_empresa as nombre_empresa, empresa.fecha_activacion as fecha_activacion, ciudad.nombre as ciudad_, empresa.rif as rif, estatus.descripcion as estatus_, isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2)  AS solv, empresa.ventas_brutas_anuales as ventas_brutas_anuales, empresa.aporte_mantenimiento as aporte_mantenimiento, empresa.categoria as categoria, empresa.division as division, empresa.grupo as grupo, empresa.clase as clase, empresa.rep_legal as rep_legal")
                    
                    render  "/empresas/index.xlsx.axlsx"

                  end 
      }

      format.pdf {




                if (params[:retiradas])
                  @empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, {:empresas_retiradas => :sub_estatus},{:empresas_retiradas => :motivo_retiro}).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("empresas_retiradas.fecha_retiro desc")
                  render "/empresas/empresas_retiradas.pdf.prawn"
                elsif params[:eliminadas]
                  @empresas = EmpresaEliminada.where("estatus.descripcion = ?", 'Eliminada').includes(:estado, :ciudad, :estatus, :clasificacion, :empresa_elim_detalle, :sub_estatus, :motivo_retiro).order("empresa_elim_detalle.fecha_eliminacion desc")
                  render "/empresas/empresas_eliminadas.pdf.prawn"
                elsif params[:activacion]
                  @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:ciudad, :estatus, :clasificacion, :tipo_usuario_empresa).order("empresa.fecha_inscripcion DESC")
                  render "/empresas/activacion_empresas.pdf.prawn"
                elsif params[:cartas_retiradas]
                  prawnto :prawn => { :top_margin => 10, :page_layout => :portrait}
                  @empresas = Empresa.find(params[:cartas_retiradas])
                  render "/empresas/cartas_retiro_masivo.pdf.prawn"

                else
                  @empresas = Empresa.where("estatus.descripcion = ?", 'Activa').joins("inner join ciudad on empresa.id_ciudad = ciudad.id inner join estatus on empresa.id_estatus = estatus.id LEFT OUTER JOIN [BDGS1DTS.MDF].dbo.fnc_CltSlv () ON empresa.prefijo = [BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo").order("empresa.fecha_activacion desc").select("empresa.prefijo as prefijo, empresa.nombre_empresa as nombre_empresa, empresa.fecha_activacion as fecha_activacion, ciudad.nombre as ciudad_, empresa.rif as rif, estatus.descripcion as estatus_, isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2)  AS solv, empresa.ventas_brutas_anuales as ventas_brutas_anuales, empresa.aporte_mantenimiento as aporte_mantenimiento, empresa.categoria as categoria, empresa.division as division, empresa.grupo as grupo, empresa.clase as clase, empresa.rep_legal as rep_legal")
                  
                  render "/empresas/index.pdf.prawn"
                end
      } 

    end

  end

  # GET /empresas/1
  # GET /empresas/1.json
  def show

    
    @empresa = Empresa.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      
      format.json {

        render json: @empresa 

      }

      format.pdf {
          
          prawnto :prawn => { :top_margin => 10, :page_layout => :portrait}
          @gln_legal = Gln.find(:first,  :include => [:tipo_gln], :conditions =>["prefijo = ? and id_tipo_gln= ? ", @empresa.prefijo, 1])
          
          @productos = Producto.find(:all, :conditions => ["prefijo = ?", @empresa.prefijo])

          if params[:retiro_individual]
            render "empresas/retiro_voluntario.pdf.prawn"
          else
            render "/empresas/carta_afiliacion.pdf.prawn"
          end
      }

    end
  end

  # GET /empresas/new
  # GET /empresas/new.json
  def new
     # la creacion de empresa es por empresa_registrada_controller
  end

  # GET /empresas/1/edit
  def edit
    
    @empresa = Empresa.find(params[:id])
    
    
  end

  # POST /empresas
  # POST /empresas.json
  def create
    # La creacion de empresa es por empresa_registrada_controller
  end

  # PUT /empresas/1
  # PUT /empresas/1.json
  def update

    @empresa = Empresa.find(params[:id])
    
    respond_to do |format|
       
      if @empresa.update_attributes(params[:empresa])

        format.html { 
          
          redirect_to '/empresas', notice: "EMPRESA #{@empresa.nombre_empresa} PREFIJO:#{@empresa.prefijo}  ACTUALIZADA SATISFACTORIAMENTE." 
          
        }

        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end



    end
  end

  def update_multiple

   
    Empresa.validar_empresas(params[:activar_empresas]) if params[:activar_empresas] #Parametro que indica Validar Empresa       
    Empresa.retirar_empresas(params) if params[:retiro]
    Empresa.eliminar_empresas(params) if params[:eliminar]
    Empresa.reactivar_empresas_retiradas(params) if params[:reactivar]
    Empresa.cambiar_sub_estatus(params) if params[:sub_estatus]

    
    @procesadas = ""
    params[:activar_empresas].collect{|prefijo| @procesadas += prefijo + " " } if params[:activar_empresas]
    params[:retirar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:retirar_empresas]
    params[:eliminar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:eliminar_empresas]
    params[:reactivar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:reactivar_empresas]
    params[:sub_estatus_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:sub_estatus]

    respond_to do |format|
          format.html { 
          redirect_to '/empresas', notice: "PREFIJO #{@procesadas} ACTIVADO"  if params[:activar_empresas]
          redirect_to '/empresas', notice: "Los Prefijos #{@procesadas} fueron retirados."  if params[:retiro]
          redirect_to '/empresas?eliminadas=true', notice: "Los Prefijos #{@procesadas} fueron eliminados."  if params[:eliminar_empresas]
          redirect_to '/empresas', notice: "Los Prefijos #{@procesadas} fueron reactivados satisfactoriamente." if params[:reactivar]  # Empresasa eliminadas que se reactivan
          redirect_to '/empresas', notice: "Los Prefijos #{@procesadas} fueron modificados sus sub estatus." if params[:sub_estatus]  
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
