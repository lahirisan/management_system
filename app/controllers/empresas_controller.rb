#encoding: UTF-8
class EmpresasController < ApplicationController
  before_filter :require_authentication
  
  # GET /empresas
  # GET /empresas.json
  
  def index

    # OJO: La llamada JSON y los parametro se establecen en el datatable desde el template.html.haml

    respond_to do |format|
      format.html{

                  cookies.clear if params[:eliminar_cookie]
                  
                  if params[:activacion]
                    render :template =>'/empresas/activacion.html.haml' 
                  elsif params[:retirar]
                    render :template =>'/empresas/retirar_empresa.html.haml'
                  elsif params[:eliminar]
                    render :template =>'/empresas/eliminar_empresa.html.haml'
                  elsif params[:eliminadas]
                    render :template =>'/empresas/empresas_eliminadas.html.haml'
                  elsif params[:retiradas]
                    @empresas_retiradas = Empresa.includes(:estatus).where("estatus.descripcion = 'Retirada'").references(:estatus)
                    render :template =>'/empresas/empresas_retiradas.html.haml'
                  elsif params[:reactivar]
                    render :template =>'/empresas/empresas_reactivar.html.haml'
                  elsif params[:reporte_empresa] == 'true'
                    
                    render :template =>'/empresas/reporte_empresa.html.haml'
                  else
                    
                    # Se verifica si tiene el privilegio para  EDITAR EMPRESA
                    if UsuariosAlcance.verificar_alcance(session[:perfil], session[:gerencia], 'Modificar Empresa') # entra en esta opción tambien si tiene privilegio para asociar prefijos a empresas existentes

                      @vista_empresa = "/empresas.json?modificar_empresa=true"

                    else

                      @vista_empresa = "/empresas.json"

                    end

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
                    
                    elsif params[:transferir] == 'true'
                      
                      render json: EmpresasTransferirGtinDatatable.new(view_context)
                    
                    else

                      

                      if UsuariosAlcance.verificar_alcance(session[:perfil], session[:gerencia], 'Modificar Empresa')  # Privilegio Modificar Empresa
                        

                        if UsuariosAlcance.verificar_alcance(session[:perfil], session[:gerencia], 'Generar Código')  ## Si tiene el privilegio asociado a su perfil puede generar codigos para PRODUCTOS Y GLN

                          render json: EmpresasEditableCodificableDatatable.new(view_context)

                        else  # Asociar Nuevo Prefijo

                          render json: EmpresasEditableDatatable.new(view_context)  

                        end

                      else

                        render json: EmpresasDatatable.new(view_context)
                        
                      end

                    end
                  }

      format.xlsx{


                  if params[:retiradas]
                   
                    render  "/empresas/empresas_retiradas.xlsx.axlsx"

                  elsif params[:eliminadas]
                    @empresas = EmpresaEliminada.includes(:estatus, :motivo_retiro).order("empresa_eliminada.fecha_eliminacion desc")
                    render "/empresas/empresas_eliminadas.xlsx.axlsx"
                  elsif params[:activacion]
                    @empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:ciudad, :estatus, :tipo_usuario_empresa, :clasificacion).order("empresa.fecha_inscripcion")
                    render "/empresas/activacion_empresas.xlsx.axlsx"
                  
                  elsif params[:reactivar] == 'true'
                    @empresas = Empresa.includes(:estado, :ciudad, :estatus,  :motivo_retiro).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("empresa.fecha_retiro desc")
                    render  "/empresas/reactivar.xlsx.axlsx"

                  else

                    
                    
                    render :template => "/empresas/index.xlsx.axlsx"


                  end 
      }

      

    end

  end

  # GET /empresas/1
  # GET /empresas/1.json
  def show

    
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:id]], :include => [:tipo_usuario_empresa])
    
    @telefono1 = Empresa.telefono1(@empresa)
    @telefono2 = Empresa.telefono2(@empresa)
    @telefono3 = Empresa.telefono3(@empresa)
    @fax = Empresa.fax(@empresa)
    
    
    @estado_ean = Estado.find(@empresa.id_estado_ean) if (@empresa.id_estado_ean) and (@empresa.id_estado_ean >= 1 and @empresa.id_estado_ean <= 25)
    @ciudad_ean = Ciudad.find(@empresa.id_ciudad_ean) if (@empresa.id_ciudad_ean) and (@empresa.id_ciudad_ean >= 1 and   @empresa.id_ciudad_ean <= 601)
    @municipio_ean = Municipio.find(@empresa.id_municipio_ean) if (@empresa.id_municipio_ean) and (@empresa.id_municipio_ean >= 1 and @empresa.id_municipio_ean <= 365)
    @telefono1_ean = Empresa.telefono1_ean(@empresa)
    @telefono2_ean = Empresa.telefono2_ean(@empresa)
    @telefono3_ean = Empresa.telefono3_ean(@empresa)
    @fax_ean = Empresa.fax_ean(@empresa)

    @estado_edi = Estado.find(@empresa.id_estado_edi) if (@empresa.id_estado_edi) and (@empresa.id_estado_edi >= 1 and @empresa.id_estado_edi <= 25)
    @ciudad_edi = Ciudad.find(@empresa.id_ciudad_edi) if (@empresa.id_ciudad_edi) and (@empresa.id_ciudad_edi >= 1 and   @empresa.id_ciudad_edi <= 601)
    @municipio_edi = Municipio.find(@empresa.id_municipio_edi) if (@empresa.id_municipio_edi) and  (@empresa.id_municipio_edi >= 1 and @empresa.id_municipio_edi <= 365)
    @telefono1_edi = Empresa.telefono1_edi(@empresa)
    @telefono2_edi = Empresa.telefono2_edi(@empresa)
    @telefono3_edi = Empresa.telefono3_edi(@empresa)
    @fax_edi = Empresa.fax_edi(@empresa)

    @estado_recursos = Estado.find(@empresa.id_estado_recursos) if (@empresa.id_estado_recursos) and (@empresa.id_estado_recursos >= 1 and @empresa.id_estado_recursos <= 25)
    @ciudad_recursos = Ciudad.find(@empresa.id_ciudad_recursos) if (@empresa.id_ciudad_recursos) and (@empresa.id_ciudad_recursos >= 1 and   @empresa.id_ciudad_recursos <= 601)
    @municipio_recursos = Municipio.find(@empresa.id_municipio_recursos) if (@empresa.id_municipio_recursos) and (@empresa.id_municipio_recursos >= 1 and @empresa.id_municipio_recursos <= 365)
    @telefono1_recursos = Empresa.telefono1_recursos(@empresa)
    @telefono2_recursos = Empresa.telefono2_recursos(@empresa)
    @telefono3_recursos = Empresa.telefono3_recursos(@empresa)
    @fax_recursos = Empresa.fax_recursos(@empresa)

    @estado_mercadeo = Estado.find(@empresa.id_estado_mercadeo) if (@empresa.id_estado_mercadeo) and  (@empresa.id_estado_mercadeo >= 1 and @empresa.id_estado_mercadeo <= 25)
    @ciudad_mercadeo= Ciudad.find(@empresa.id_ciudad_mercadeo)  if (@empresa.id_ciudad_mercadeo) and  (@empresa.id_ciudad_mercadeo >= 1 and   @empresa.id_ciudad_mercadeo <= 601)
    @municipio_mercadeo = Municipio.find(@empresa.id_municipio_mercadeo) if (@empresa.id_municipio_mercadeo) and (@empresa.id_municipio_mercadeo >= 1 and @empresa.id_municipio_mercadeo <= 365)
    @telefono1_mercadeo = Empresa.telefono1_mercadeo(@empresa)
    @telefono2_mercadeo = Empresa.telefono2_mercadeo(@empresa)
    @telefono3_mercadeo = Empresa.telefono3_mercadeo(@empresa)
    @fax_mercadeo = Empresa.fax_mercadeo(@empresa)

    respond_to do |format|
      format.html # show.html.erb

      @clasificacion = Clasificacion.find(:first, :conditions => ["categoria = ? and division = ? and grupo = ? and clase = ?", @empresa.categoria, @empresa.division, @empresa.grupo, @empresa.clase])
      
      
      format.json {

        render json: @empresa 

      }

      format.pdf {
          
          @gln_legal = Gln.find(:first,  :include => [:tipo_gln], :conditions =>["prefijo = ? and id_tipo_gln= ? ", @empresa.prefijo, 1])
          @productos = Producto.find(:all, :conditions => ["prefijo = ?", @empresa.prefijo], :include => [:tipo_gtin])

          if params[:retiro_individual]
            pdf = RetiroVoluntarioPdf.new(@empresa,@productos)
          else
            pdf = CartaAfiliacionPdf.new(@empresa,@gln_legal)
          end
          send_data pdf.render, filename: "#{@empresa.nombre_empresa}.pdf", type: "application/pdf", disposition: "inline"
      }

    end
  end

 
  # GET /empresas/1/edit
  def edit
    
    @empresa = Empresa.find(params[:id])
    @nuevo_prefijo_asociado = Empresa.busqueda_exhaustiva_prefijo if params[:asociar_prefijo] == 'true'
    @clasificacion = Clasificacion.where("categoria = '#{@empresa.categoria}' and division = #{@empresa.division} and grupo = #{@empresa.grupo} and clase = #{@empresa.clase}").first

    
    
  end

  # POST /empresas
  # POST /empresas.json
  def create
    #prawnto :prawn => { :top_margin => 10, :page_layout => :portrait}
    respond_to do |format|
       format.pdf {
          if params[:retiro_masivo_cartas]
                    
          @empresas = Empresa.find(params[:retiro_masivo_cartas].split)

          pdf = EmpresasRetiradasPdf.new(@empresas)

          send_data pdf.render, filename: "empresas_retiradas.pdf", type: "application/pdf", disposition: "inline"
          
          #render "/empresas/cartas_retiro_masivo.pdf.prawn"

          end
        }

    end

    
  end

  # PUT /empresas/1
  # PUT /empresas/1.json
  def update

    @empresa = Empresa.find(params[:id])
    
    params[:empresa][:rif_completo] = params[:empresa][:tipo_rif] + "-" + params[:empresa][:rif]

    respond_to do |format|
       
      if params[:asociar_prefijo] == 'true'# Opcion para asignar nuevos prefijos a las empresas
        Empresa.update(@empresa.prefijo, :no_rif_validation => true) # La empresa a la que se le esta asociando un nuevo prefijo puede tener rif_repetidos
        EmpresaRegistrada.asociar_prefijo(params[:empresa], @empresa.fecha_inscripcion)
        Auditoria.registrar_evento(session[:usuario],"Nueva Empresa", "Asociar Nuevo Prefijo", Time.now, "EMPRESA:#{params[:empresa][:nombre_empresa]} RIF:#{params[:empresa][:tipo_rif]}-#{params[:empresa][:rif]}")
        
        format.html { 
          redirect_to '/empresa_registradas', notice: "SE REGISTRO EMPRESA #{params[:empresa][:nombre_empresa]} RIF:#{params[:empresa][:tipo_rif]}-#{params[:empresa][:rif]}"
        }

      else # Se esta editando la empresa
        
        ############################ LOS DATOS SE CAMBIA A MAYUSCULA    ##########################################

        params[:empresa][:nombre_empresa] = params[:empresa][:nombre_empresa].upcase if params[:empresa][:nombre_empresa]
        params[:empresa][:nombre_comercial] =  params[:empresa][:nombre_comercial].upcase if params[:empresa][:nombre_comercial]
        params[:empresa][:direccion_empresa] = params[:empresa][:direccion_empresa].upcase if params[:empresa][:direccion_empresa]
        params[:empresa][:circunscripcion_judicial] = params[:empresa][:circunscripcion_judicial].upcase if params[:empresa][:circunscripcion_judicial]
        params[:empresa][:rep_legal] = params[:empresa][:rep_legal].upcase if params[:empresa][:rep_legal]
        params[:empresa][:cargo_rep_legal] = params[:empresa][:cargo_rep_legal].upcase if params[:empresa][:cargo_rep_legal]
        params[:empresa][:nacionalidad_responsable_legal] = params[:empresa][:nacionalidad_responsable_legal].upcase if params[:empresa][:nacionalidad_responsable_legal]
        params[:empresa][:domicilio_responsable_legal] = params[:empresa][:domicilio_responsable_legal].upcase if params[:empresa][:domicilio_responsable_legal]


        # DATOS EAN SE LLEVAN A MAYUSCULAS

        params[:empresa][:rep_ean] = params[:empresa][:rep_ean].upcase if params[:empresa][:rep_ean]
        params[:empresa][:rep_ean_cargo] = params[:empresa][:rep_ean_cargo].upcase if params[:empresa][:rep_ean_cargo]
        params[:empresa][:galpon_edificio_quinta] = params[:empresa][:galpon_edificio_quinta].upcase if params[:empresa][:galpon_edificio_quinta]
        params[:empresa][:oficina_apartamento] = params[:empresa][:oficina_apartamento].upcase if params[:empresa][:oficina_apartamento]
        params[:empresa][:avenida_calle] = params[:empresa][:avenida_calle].upcase if params[:empresa][:avenida_calle]
        params[:empresa][:urbanizacion_barrio_sector] = params[:empresa][:urbanizacion_barrio_sector].upcase if params[:empresa][:urbanizacion_barrio_sector]
        params[:empresa][:parroquia_ean] = params[:empresa][:parroquia_ean].upcase if params[:empresa][:parroquia_ean]
        params[:empresa][:punto_ref_ean] = params[:empresa][:punto_ref_ean].upcase if params[:empresa][:punto_ref_ean]


        # DATOS CORREO ELECTRONICO Y SINCRONET SE LLEVAN A MAYUSCULAS

        params[:empresa][:rep_edi] = params[:empresa][:rep_edi].upcase if params[:empresa][:rep_edi]
        params[:empresa][:rep_edi_cargo] = params[:empresa][:rep_edi_cargo].upcase if params[:empresa][:rep_edi_cargo]
        params[:empresa][:galpon_edificio_quinta_sincronet] = params[:empresa][:galpon_edificio_quinta_sincronet].upcase if params[:empresa][:galpon_edificio_quinta_sincronet]
        params[:empresa][:piso_numero_sincronet] =  params[:empresa][:piso_numero_sincronet].upcase if params[:empresa][:piso_numero_sincronet]
        params[:empresa][:oficina_apartamento_sincronet] = params[:empresa][:oficina_apartamento_sincronet].upcase if params[:empresa][:oficina_apartamento_sincronet]
        params[:empresa][:avenida_calle_sincronet] = params[:empresa][:avenida_calle_sincronet].upcase if params[:empresa][:avenida_calle_sincronet]
        params[:empresa][:urbanizacion_barrio_sector_sincronet] = params[:empresa][:urbanizacion_barrio_sector_sincronet].upcase if params[:empresa][:urbanizacion_barrio_sector_sincronet]
        params[:empresa][:parroquia_edi] = params[:empresa][:parroquia_edi].upcase if params[:empresa][:parroquia_edi]
        params[:empresa][:punto_ref_edi] = params[:empresa][:punto_ref_edi].upcase if params[:empresa][:punto_ref_edi]

        
        # DATOS RECURSOS SE LLEVAN A MAYUSCULA    
        
        params[:empresa][:rep_recursos] = params[:empresa][:rep_recursos].upcase if params[:empresa][:rep_recursos]
        params[:empresa][:rep_recursos_cargo] = params[:empresa][:rep_recursos_cargo].upcase if params[:empresa][:rep_recursos_cargo]

        # DATOS MERCADEO SE LLEVAN A MAYUSCULA

        params[:empresa][:rep_mercadeo] = params[:empresa][:rep_mercadeo].upcase if params[:empresa][:rep_mercadeo]
        params[:empresa][:rep_mercadeo_cargo] = params[:empresa][:rep_mercadeo_cargo].upcase if params[:empresa][:rep_mercadeo_cargo]
        
        # Se obtienen los numeros completos

        params[:empresa][:contacto_tlf1_completo] =  "("+ params[:empresa][:cod_contacto_tlf1] + ")" +" "+ params[:empresa][:contacto_tlf1] if params[:empresa][:cod_contacto_tlf1] != ""
        params[:empresa][:contacto_tlf2_completo] = "("+ params[:empresa][:cod_contacto_tlf2] + ")"+ " " + params[:empresa][:contacto_tlf2] if params[:empresa][:cod_contacto_tlf2] != ""
        params[:empresa][:contacto_tlf3_completo] ="("+ params[:empresa][:cod_contacto_tlf3] + ")" +" "+ params[:empresa][:contacto_tlf3] if params[:empresa][:cod_contacto_tlf3] != ""
        params[:empresa][:contacto_fax_completo] = "("+params[:empresa][:cod_contacto_fax] + ")" +" "+ params[:empresa][:contacto_fax] if params[:empresa][:cod_contacto_fax] != ""
        params[:empresa][:direccion_ean] = params[:empresa][:tipo_urbanizacion_barrio_sector] + " " + params[:empresa][:urbanizacion_barrio_sector] + " " + params[:empresa][:tipo_avenida_calle]  + " " + params[:empresa][:avenida_calle] + " " + params[:empresa][:tipo_galpon_edificio_quinta] + " " + params[:empresa][:galpon_edificio_quinta] + " " + params[:empresa][:tipo_piso_numero] + " " + params[:empresa][:piso_numero]  + " " + params[:empresa][:tipo_oficina_apartamento] + " " + params[:empresa][:oficina_apartamento] 
        params[:empresa][:telefono1_ean_completo] = "("+ params[:empresa][:cod_tlf1_ean] + ")" +" "+ params[:empresa][:telefono1_ean] if params[:empresa][:cod_tlf1_ean] != ""
        params[:empresa][:telefono2_ean_completo] = "("+ params[:empresa][:cod_tlf2_ean] + ")" +" "+ params[:empresa][:telefono2_ean] if params[:empresa][:cod_tlf2_ean] != ""
        params[:empresa][:telefono3_ean_completo] = "("+ params[:empresa][:cod_tlf3_ean] + ")" +" "+ params[:empresa][:telefono3_ean] if params[:empresa][:cod_tlf3_ean] != ""
        params[:empresa][:fax_ean_completo] = "("+ params[:empresa][:cod_fax_ean] + ")" +" "+ params[:empresa][:fax_ean]              if params[:empresa][:cod_fax_ean] != ""  

        # SE OBTIENE EL RIF COMPLETO

        params[:empresa][:rif_completo] = params[:empresa][:tipo_rif] + "-" + params[:empresa][:rif]


        if @empresa.update_attributes(params[:empresa])


          Auditoria.registrar_evento(session[:usuario],"empresa", "Editar", Time.now, "Empresa:#{@empresa.nombre_empresa} PREFIJO:#{@empresa.prefijo}")

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

  end

  def update_multiple
   
    Empresa.validar_empresas(params[:activar_empresas]) if params[:activar_empresas] #Parametro que indica Validar Empresa       
    
    if params[:retiro]
      
      
      for empresa in (0..params[:retirar_empresas].size-1)
        empresa_seleccionada =  params[:retirar_empresas][empresa] ### Ojo con esto mejorarlo, este formato es muy sensible a fallas
        
        Empresa.retirar_empresas(params[:retirar_empresas][empresa], params[:"#{empresa_seleccionada}"].split('_')[1].to_i) # Se pasa el prefijo de la  empresa a retirar
        Auditoria.registrar_evento(session[:usuario],"empresa", "Retirar", Time.now, "#{params[:retirar_empresas][empresa]}")

      end 

    

    end

    if params[:eliminar]

      Empresa.eliminar_empresas(params) 
      params[:eliminar_empresas].collect{|empresa_eliminar| @empresa = EmpresaEliminada.find(empresa_eliminar); Auditoria.registrar_evento(session[:usuario],"empresa", "Eliminar", Time.now, "Empresa:#{@empresa.nombre_empresa.strip} PREFIJO:#{@empresa.prefijo}") }

    end
    
    Empresa.reactivar_empresas_retiradas(params) if params[:reactivar]
    
    @procesadas = ""
    params[:activar_empresas].collect{|prefijo| @procesadas += prefijo + " " } if params[:activar_empresas]
    params[:retirar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:retirar_empresas]
    params[:eliminar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:eliminar_empresas]
    params[:reactivar_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:reactivar_empresas]
    params[:sub_estatus_empresas].collect{|prefijo| @procesadas += prefijo + " "} if params[:sub_estatus]

    respond_to do |format|
          format.html { 
          redirect_to '/empresas', notice: "PREFIJO #{@procesadas} ACTIVADO"  if params[:activar_empresas]
          redirect_to '/empresas?retirar=true', notice: "El(los) Prefijo(s) #{@procesadas} fueron retirados."  if params[:retiro]
          redirect_to '/empresas?eliminar=true', notice: "El(los) Prefijo(s) #{@procesadas} fueron eliminados."  if params[:eliminar_empresas]
          redirect_to '/empresas?reactivar=true ', notice: "El(los) Prefijo(s) #{@procesadas} fueron reactivados satisfactoriamente." if params[:reactivar]  # Empresasa eliminadas que se reactivan
          redirect_to '/empresas', notice: "El(los) Prefijo(s) #{@procesadas} fueron modificados sus sub estatus." if params[:sub_estatus]  
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
