class ProductosController < ApplicationController
  # GET /productos
  # GET /productos.json
  def index

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
                      render json: (ProductosDatatable.new(view_context))
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
    @producto = Producto.new
    @gtin = "nada"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @producto }
    end
  end

  # GET /productos/1/edit
  def edit
    @producto = Producto.find(:first, :conditions => ["gtin like ?", params[:id]])

  end

  # POST /productos
  # POST /productos.json
  def create

    
    Producto.crear_gtin(params[:producto][:id_tipo_gtin])

    @producto = Producto.new(params[:producto])

    respond_to do |format|
      if @producto.save
        format.html { redirect_to @producto, notice: "EL GTIN #{params[:id]} fue actualizado satisfactoriamente" }
        format.json { render json: @producto, status: :created, location: @producto }
      else
        format.html { render action: "new" }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /productos/1
  # PUT /productos/1.json
  def update
    
      @producto = Producto.find(:first, :conditions => ["gtin like ?", params[:id]])

    respond_to do |format|
      if @producto.update_attributes(params[:producto])
        format.html { redirect_to productos_path, notice: "EL GTIN #{params[:id]} fue actualizado satisfactoriamente" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def update_multiple

    Producto.retirar(params) if params[:retirar]
    Producto.eliminar(params) if params[:eliminar]
    
    respond_to do |format|
      format.html { redirect_to '/productos?retirar=true', notice: "Los GTIN #{params[:retirar_productos]} fueron retirados satisfactoriamente." }
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
