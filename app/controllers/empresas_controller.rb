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
                    @empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, {:empresas_retiradas => :sub_estatus},{:empresas_retiradas => :motivo_retiro}).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("empresas_retiradas.fecha_retiro desc")
                    render  "/empresas/empresas_retiradas.xlsx.axlsx"

                  elsif params[:eliminadas]
                    @empresas = EmpresaEliminada.includes(:estado, :ciudad, :estatus, :clasificacion, :empresa_elim_detalle, :sub_estatus, :motivo_retiro).order("empresa_elim_detalle.fecha_eliminacion desc")
                    render "/empresas/empresas_eliminadas.xlsx.axlsx"
                  elsif params[:activacion]
                    @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:ciudad, :estatus, :tipo_usuario_empresa, :clasificacion).order("empresa.fecha_inscripcion")
                    render "/empresas/activacion_empresas.xlsx.axlsx"
                  else
                    @empresas = Empresa.includes( :estado, :ciudad, :estatus, :clasificacion, :sub_estatus).where("estatus.descripcion = ?", 'Activa').order("empresa.fecha_activacion desc")
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
                else
                  @empresas = Empresa.includes( :ciudad, :estatus, :clasificacion, :sub_estatus).where("estatus.descripcion = ?", 'Activa').order("empresa.fecha_activacion desc")
                  render "/empresas/index.pdf.prawn"
                end
      } 

    end

  end

  # GET /empresas/1
  # GET /empresas/1.json
  def show

    (params[:eliminados]) ? (@empresa = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:id]])) : (@empresa = Empresa.find(params[:id]))
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @empresa }

      format.pdf {
          
          prawnto :prawn => { :top_margin => 10, :page_layout => :portrait}
          @gln_legal = Gln.find(:first,  :include => [:tipo_gln], :conditions =>["prefijo = ? and id_tipo_gln= ? ", @empresa.prefijo, 1])
          
          render "/empresas/carta_afiliacion.pdf.prawn"
      }

    end
  end

  # GET /empresas/new
  # GET /empresas/new.json
  def new

    
    @empresa = Empresa.new
    
    respond_to do |format|
      
      format.html {

        
      }

      format.json {

      }

        
    end
  end

  # GET /empresas/1/edit
  def edit
    
    @empresa = Empresa.find(params[:id])
    
    if (session[:perfil] == 'Super Usuario' and session[:gerencia] == 'Estandares y Consultoría') or (sessio[:perfil] == 'Administrador' and session[:gerencia] == 'Estandares y Consultoría')
      
      @clasificacion_empresa = Clasificacion.find(:first, :conditions => ["categoria = ? and division = ? and grupo = ? and clase = ?", @empresa.categoria, @empresa.division, @empresa.grupo, @empresa.clase])
      #@prefijos_retirados_activos = Empresa.find(:all, :include => [:estatus], :conditions => ["estatus.descripcion in (?) and estatus.alcance = ?", ['Activa', 'Retirada'], 'Empresa'], :select => "empresa.prefijo")
      #@prefijos_disponibles = EmpresaEliminada.find(:all, :include => [:estatus], :conditions => ["(categoria = ? or division = ? or grupo = ? or clase = ?) and prefijo not in (?)", @empresa.categoria, @empresa.division, @empresa.grupo, @empresa.clase, @prefijos_retirados_activos.collect{|empresa| empresa.prefijo}], :select => "empresa.prefijo, empresa.nombre_empresa, clasificacion.descripcion, estatus.descripcion")

    end
    

  end

  # POST /empresas
  # POST /empresas.json
  def create

    
    #empresa_no_validada = Empresa.find(:first, :include => [:estatus], :conditions => ["prefijo = ? and estatus.descripcion = ?", params[:empresa][:prefijo], 'No Validado'])
    #prefijo_eliminado = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:empresa][:prefijo]])
    
    #Empresa.utilizar_prefijo_no_validado(empresa_no_validada) if empresa_no_validada
    
    params[:empresa][:id_estatus] = Estatus.empresa_inactiva()
    # Se completa la hora con los segundos para que pueda ordenar por la ultima creada
    time = Time.now
    params[:empresa][:fecha_inscripcion] = Time.now
    params[:empresa][:prefijo] =  Empresa.generar_prefijo_valido
    
    params[:empresa][:id_tipo_usuario] = 3 if params[:empresa][:id_tipo_usuario] == '' # Si el usaurio no especifico el tipo de empresa
    params[:empresa][:contacto_tlf1] =  params[:codigo_telefono1] + "-" + params[:empresa][:contacto_tlf1] if params[:codigo_telefono1] != ""
    params[:empresa][:contacto_tlf2] = params[:codigo_telefono2] + "-" + params[:empresa][:contacto_tlf2] if params[:codigo_telefono2] != ""
    params[:empresa][:contacto_tlf3] = params[:codigo_telefono3] + "-" + params[:empresa][:contacto_tlf3] if params[:codigo_telefono3] != ""
    params[:empresa][:contacto_fax] = params[:codigo_telefono4] + "-" + params[:empresa][:contacto_fax] if params[:codigo_telefono4] != ""

    
    @empresa = Empresa.new(params[:empresa])
    
    respond_to do |format|
      
      
      if @empresa.save
  
        
        # EL GLN OJO con esto  validar los casos GLN para empresa no validad y GLN de emrpresas eliminadas
        
        Gln.generar_legal(@empresa.prefijo.to_s) #if empresa_no_validada.nil?

        Auditoria.registrar_evento(session[:user_id],"Empresa", "Crear", Time.now, "Prefijo #{@empresa.prefijo}")
        format.html { 
         if session[:gerencia] == 'Estandares y Consultoría' or session[:perfil] == 'Administrador' or session[:perfil] == 'Super Usuario'
          redirect_to '/empresas?activacion=true', notice: "EMPRESA CREADA SATISFACTORIAMENTE. PREFIJO:#{@empresa.prefijo}   NOMBRE:#{@empresa.nombre_empresa}"
         else
          redirect_to '/empresas?activacion=true', notice: "EMPRESA CREADA SATISFACTORIAMENTE. NOMBRE:#{@empresa.nombre_empresa} RIF:#{@empresa.rif}"
         end
        }

       else
          format.html { render action: "new" }
       end
    end
  end

  # PUT /empresas/1
  # PUT /empresas/1.json
  def update


    @empresa = Empresa.find(params[:id])

    
    if (session[:gerencia] == 'Estandares y Consultoría')  and (params[:empresa][:prefijo] != @empresa.prefijo)
      
      estatus = Estatus.find(:first, :conditions => ["descripcion = ? and alcance = ?", 'Activa', 'Empresa'])
      estatus_administrativo = SubEstatus.find(:first, :conditions => ["descripcion = ?", 'SOLVENTE'])
      params[:empresa][:id_subestatus] = estatus_administrativo.id
      params[:empresa][:id_estatus] = estatus.id  # Empresa activa
      params[:empresa][:fecha_activacion] = Time.now

     
        gln = params[:empresa][:prefijo] + "90001"
        digito_verificacion = Producto.calcular_digito_verificacion(gln.to_i, "GTIN-13")
        gln = gln +  digito_verificacion.to_s

       Gln.where(:prefijo => @empresa.prefijo).update_all("prefijo = #{params[:empresa][:prefijo]}, gln = #{gln}")  

       Empresa.where(:prefijo => @empresa.prefijo).update_all("prefijo = #{params[:empresa][:prefijo]}")

       # registro en una tabla de historico eliminadas

       # eliminada = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:empresa][:prefijo]])

       # historico_eliminada = HistoricoEliminada.new
       # historico_eliminada.prefijo = eliminada.prefijo
       # historico_eliminada.nombre_empresa = eliminada.nombre_empresa
       # historico_eliminada.rif = eliminada.rif
       # historico_eliminada.rep_legal = eliminada.rep_legal
       # historico_eliminada.contacto_tlf1 = eliminada.contacto_tlf1
       # historico_eliminada.contacto_email1 = eliminada.contacto_email1
       # historico_eliminada.fecha_liberacion_prefijo = Time.now
       # historico_eliminada.save
       # eliminada.destroy

       
    end



    respond_to do |format|
       
      if @empresa.update_attributes(params[:empresa])


        format.html { 
          if session[:gerencia] == 'Estandares y Consultoría' or session[:perfil] == 'Administrador' or session[:perfil] == 'Super Usuario'

            redirect_to '/empresas', notice: "EMPRESA CON PREFIJO #{@empresa.prefijo} ACTUALIZADA SATISFACTORIAMENTE." 
          else
            redirect_to '/empresas?activacion=true', notice: "EMPRESA #{@empresa.nombre_empresa} ACTUALIZADA SATISFACTORIAMENTE." 
          end
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
          redirect_to '/empresas?retiradas=true', notice: "Los Prefijos #{@procesadas} fueron retirados."  if params[:retiro]
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


  def self.attributes_protected_by_default
    []
  end

end
