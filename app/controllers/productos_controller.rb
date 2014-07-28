class ProductosController < ApplicationController
  before_filter :require_authentication
  # GET /productos
  # GET /productos.json
  
  prawnto :prawn => { :top_margin => 10} 

  def index
    

    productos = Producto.where("productos_empresa.prefijo = ?", params[:empresa_id]).includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin).order("productos.fecha_inscripcion") 
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @empresa = EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]]) if @empresa.nil?

    respond_to do |format|
      format.html {
                    if params[:retirar]
                      @navegabilidad = @empresa.nombre_empresa + " > Retirar Productos" 
                      render :template =>'/productos/retirar_productos.html.haml'
                    elsif params[:retirados]
                      @navegabilidad = @empresa.nombre_empresa + " > Productos Retirados"
                      render :template =>'/productos/productos_retirados.html.haml'
                    elsif params[:eliminar]
                      @navegabilidad = @empresa.nombre_empresa + "> Productos Retirados > Eliminar Productos"
                      render :template =>'/productos/eliminar_productos.html.haml'
                    elsif params[:eliminados]
                      @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
                      @empresa = @empresa ?  @empresa : EmpresaEliminada.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
                      @navegabilidad = @empresa.nombre_empresa + " > Productos Eliminados"
                      render :template =>'/productos/productos_eliminados.html.haml'
                    else
                      @navegabilidad = @empresa.nombre_empresa + " > Productos Activos > Listado"
                      render :template =>'/productos/index.html.haml'

                    end
                  }
      format.json { 
                    
                    if params[:retirar]
                      render json: (RetirarProductosDatatable.new(view_context))
                    elsif params[:gtin]
                      gtin = params[:gtin]
                      digito_verificacion = Producto.calcular_digito_verificacion(params[:gtin].to_i,"GTIN-13")
                      codigo_generado =  gtin + digito_verificacion.to_s
                      producto = ProductosEmpresa.find(:first, :conditions => ["prefijo = ? and gtin = ?", params[:prefijo], codigo_generado])
                      render json: producto
                    elsif params[:retirados]
                      render json: (ProductosRetiradosDatatable.new(view_context))
                    elsif params[:eliminar]
                      render json: (EliminarProductosDatatable.new(view_context))
                    elsif params[:eliminados]
                      render json: (ProductosEliminadosDatatable.new(view_context))
                    else
                      if UsuariosAlcance.verificar_alcance(session[:perfil], 'Modificar Producto')
                        render json: ProductosDatatable.new(view_context) 
                      else
                        render json: ProductosNotEditableDatatable.new(view_context) 
                      end
                    end
                  }
      format.pdf  {
                    if params[:retirar]
                      @productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion = ?", params[:empresa_id], 'Activo').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin).order("producto.fecha_creacion") 
                      render '/productos/retirar_productos.pdf.prawn'
                    elsif params[:retirados]
                      @productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?",params[:empresa_id], 'Retirado', 'Producto').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin, {:productos_retirados => :sub_estatus}, {:productos_retirados => :motivo_retiro})
                      render '/productos/productos_retirados.pdf.prawn'
                    elsif params[:eliminar]
                      @productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?",params[:empresa_id], 'Retirado', 'Producto').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin, {:productos_retirados => :sub_estatus}, {:productos_retirados => :motivo_retiro})
                      render '/productos/eliminar_productos.pdf.prawn'
                    elsif params[:eliminados]
                      @productos = ProductoEliminado.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?", params[:empresa_id], 'Eliminado', 'Producto').includes(:estatus, :tipo_gtin, {:producto_elim_detalle => :sub_estatus}, {:producto_elim_detalle => :motivo_retiro}, {:productos_empresa => :empresa})
                      render '/productos/productos_eliminados.pdf.prawn'
                    else
                      @productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion = ?", params[:empresa_id], 'Activo').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin).order("producto.fecha_creacion") 
                      render '/productos/index.pdf.prawn'
                    end
      }
      format.xlsx{
                  if params[:retirar]
                    @productos = Producto.where("productos_empresa.prefijo = ?", params[:empresa_id]).includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin).order("producto.fecha_creacion") 
                    render '/productos/retirar_productos.xlsx.axlsx'
                  elsif params[:retirados]
                    @productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?",params[:empresa_id], 'Retirado', 'Producto').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin, {:productos_retirados => :sub_estatus}, {:productos_retirados => :motivo_retiro})
                    render '/productos/productos_retirados.xlsx.axlsx'
                  elsif params[:eliminar]
                    @productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?",params[:empresa_id], 'Retirado', 'Producto').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin, {:productos_retirados => :sub_estatus}, {:productos_retirados => :motivo_retiro})
                    render '/productos/eliminar_productos.xlsx.axlsx'
                  elsif params[:eliminados]
                    @productos = ProductoEliminado.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?", params[:empresa_id], 'Eliminado', 'Producto').includes(:estatus, :tipo_gtin, {:producto_elim_detalle => :sub_estatus}, {:producto_elim_detalle => :motivo_retiro}, {:productos_empresa => :empresa})
                    render '/productos/productos_eliminados.xlsx.axlsx'
                  else
                    @productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion = ?", params[:empresa_id], 'Activo').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin).order("producto.fecha_creacion") 
                    render '/productos/index.xlsx.axlsx'
                  end
      }
      
    end
  end

  # GET /productos/1
  # GET /productos/1.json
  def show
    @producto = Producto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @producto }
    end
  end

  # GET /productos/new
  # GET /productos/new.json
  def new
    

    @empresa =  Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]] )
    @producto = @empresa.producto.build  # Se crea el form_for
    
    @gtin = params[:gtin] if params[:gtin] != ''# SI esta gtin  es para crear gtin tipo 14 base 8 o gtin 14 base 13

    @producto_ = Producto.find(:first, :conditions => ["gtin like ?", params[:gtin]]) if params[:gtin]
    @base = TipoGtin.find(:first, :conditions =>["tipo like ? and base like ?", "GTIN-14", @producto_.tipo_gtin.tipo]) if @producto_


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @producto }
    end
  end

  # GET /productos/1/edit
  def edit
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @producto = Producto.find(:first, :conditions => ["gtin like ?", params[:id]])

  end

  # POST /productos
  # POST /productos.json
  def create

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])

    @gtin = params[:gtin]  if params[:gtin] != ''

    #Producto.crear_gtin(params[:producto][:id_tipo_gtin], params[:empresa_id], params[:gtin], params[:producto][:codigo_prod])
    params[:producto][:gtin] = Producto.crear_gtin(params[:producto][:id_tipo_gtin], params[:empresa_id], params[:gtin], params[:producto][:codigo_prod])
    params[:producto][:fecha_creacion] = Time.now
    estatus = Estatus.find(:first, :conditions => ["(descripcion = ?) and (alcance = ?)", "Activo", "Producto"])
    params[:producto][:id_estatus] = estatus.id
    
    params[:producto][:codigo_prod] = params[:producto][:gtin][7..11] if params[:producto][:id_tipo_gtin] == '3'
    params[:producto][:codigo_prod] = params[:producto][:gtin][3..6] if params[:producto][:id_tipo_gtin] == '1'
    params[:producto][:codigo_prod] = params[:producto][:gtin][9..12] if params[:producto][:id_tipo_gtin] == '4' 
    params[:producto][:codigo_prod] = params[:producto][:gtin][8..12] if params[:producto][:id_tipo_gtin] == '6'


    @producto = Producto.new(params[:producto])

    respond_to do |format|
      if @producto.save
        Producto.asociar_producto_empresa(params[:empresa_id],params[:producto][:gtin]) # Se asocia el producto con la empresa
        format.html { redirect_to empresa_productos_path, notice: "EL #{@producto.tipo_gtin.tipo} #{@producto.gtin} fue creado correctamente." }        
      else
        format.html { 
          
          render action: "new" }        
      end
    end
  end

  # PUT /productos/1
  # PUT /productos/1.json
  def update
    

    @producto = Producto.find(:first, :conditions => ["gtin like ?", params[:id]])

    respond_to do |format|
      if @producto.update_attributes(params[:producto])
        format.html { redirect_to empresa_productos_path, notice: "EL GTIN #{@producto.gtin} fue actualizado." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def update_multiple

    
    if params[:retirar]
      Producto.retirar(params) 
      accion = "fueron retirados."
      string_gtin = ""
      params[:retirar_productos].collect{|gtin| string_gtin += gtin + " "} 
    elsif params[:eliminar]
      Producto.eliminar(params)
      accion = "fueron eliminados."
      string_gtin = ""
      params[:eliminar_productos].collect{|gtin| string_gtin += gtin + " "} 
    end



    
    respond_to do |format|
      format.html { redirect_to "/empresas/#{params[:empresa_id]}/productos?retirados=true", notice: "Los GTIN #{string_gtin} #{accion}" } if params[:retirar]
      format.html { redirect_to "/empresas/#{params[:empresa_id]}/productos?eliminados=true", notice: "Los GTIN #{string_gtin} #{accion}" } if params[:eliminar]
    end
  end

  def import
    tipo_gtin = TipoGtin.find(params[:tipo_gtin])

    if (params[:tipo_gtin] == '6') or (params[:tipo_gtin] == '4') # Gtin14 base 8 or GTIN14 base 13
      Producto.import_gtin_14(params[:file], params[:tipo_gtin], params[:empresa_id]) 
      mensaje = "Los #{tipo_gtin.tipo} base #{tipo_gtin.base} fueron importados." 
    else
      Producto.import(params[:file], params[:tipo_gtin], params[:empresa_id]) 
      mensaje = "Los #{tipo_gtin.tipo} fueron importados." 
    end

   
    redirect_to "/empresas/#{params[:empresa_id]}/productos", notice: mensaje 

  end



  # DELETE /productos/1
  # DELETE /productos/1.json
  def destroy
    @producto = Producto.find(params[:id])
    @producto.destroy

    respond_to do |format|
      format.html { redirect_to productos_url }
      format.json { head :no_content }
    end
  end
end
