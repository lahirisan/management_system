class ProductosController < ApplicationController
  # GET /productos
  # GET /productos.json
  def index

    @prefijo = params[:empresa_id]

    respond_to do |format|
      format.html {
                    if params[:retirar]
                      render :template =>'/productos/retirar_productos.html.haml'
                    elsif params[:retirados]
                      render :template =>'/productos/productos_retirados.html.haml'
                    elsif params[:eliminar]
                      render :template =>'/productos/eliminar_productos.html.haml'
                    elsif params[:eliminados]
                      render :template =>'/productos/productos_eliminados.html.haml'
                    else
                      render :template =>'/productos/index.html.haml'
                    end
                  }
      format.json { 
                  	if params[:retirar]
                      render json: (RetirarProductosDatatable.new(view_context))
                    elsif params[:retirados]
                      render json: (ProductosRetiradosDatatable.new(view_context))
                    elsif params[:eliminar]
                      render json: (EliminarProductosDatatable.new(view_context))
                    elsif params[:eliminados]
                      render json: (ProductosEliminadosDatatable.new(view_context))
                    else
                      render json: ProductosDatatable.new(view_context) 
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
    

    @prefijo = params[:empresa_id]
    @producto = Producto.new
    @gtin = params[:gtin]

    @producto_ = Producto.find(:first, :conditions => ["gtin like ?", params[:gtin]]) if params[:gtin]
    
    @base = TipoGtin.find(:first, :conditions =>["tipo like ? and base like ?", "GTIN-14", @producto_.tipo_gtin.tipo]) if @producto_

    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @producto }
    end
  end

  # GET /productos/1/edit
  def edit
    @prefijo = params[:empresa_id]
    @producto = Producto.find(:first, :conditions => ["gtin like ?", params[:id]])

  end

  # POST /productos
  # POST /productos.json
  def create
    
    params[:producto][:gtin] = Producto.crear_gtin(params[:producto][:id_tipo_gtin], params[:prefijo], params[:gtin])
    params[:producto][:fecha_creacion] = Time.now
    
    @producto = Producto.new(params[:producto])

    respond_to do |format|
      if @producto.save
        format.html { redirect_to "/empresas/#{params[:prefijo]}/productos", notice: "EL #{@producto.tipo_gtin.tipo} #{@producto.gtin} fue creado." }        
      else
        format.html { render action: "new" }        
      end
    end
  end

  # PUT /productos/1
  # PUT /productos/1.json
  def update
    
    @producto = Producto.find(:first, :conditions => ["gtin like ?", params[:id]])

    respond_to do |format|
      if @producto.update_attributes(params[:producto])
        format.html { redirect_to "/empresas/#{params[:prefijo]}/productos", notice: "EL GTIN #{@producto.gtin} fue actualizado." }
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
      format.html { redirect_to "/empresas/#{params[:empresa_id]}/productos?retirar=true", notice: "Los GTIN #{string_gtin} #{accion}" }
    end
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
