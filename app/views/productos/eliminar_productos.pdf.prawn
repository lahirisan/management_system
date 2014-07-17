if params[:tipo_gtin] != ''
  @productos = @productos.where("tipo_gtin.tipo like :search", search: "%#{params[:tipo_gtin]}%" )
end

if params[:gtin] != ''
  @productos = @productos.where("producto.gtin like :search", search: "%#{params[:gtin]}%" )
end

if params[:descripcion] != ''
  @productos = @productos.where("producto.descripcion like :search", search: "%#{params[:descripcion]}%" )
end

if params[:marca]. != ''
  @productos = @productos.where("producto.marca like :search", search: "%#{params[:marca]}%" )
end

if params[:codigo_producto] != ''
  @productos = @productos.where("producto.codigo_prod like :search", search: "%#{params[:codigo_producto]}%" )
end

if params[:fecha_creacion] != ''
  @productos = @productos.where("producto.fecha_creacion like :search", search: "%#{params[:fecha_creacion]}%" )
end

if params[:motivo_retiro] != ''
  @productos = @productos.where("motivo_retiro.descripcion like :search", search: "%#{params[:motivo_retiro]}%" )
end

if params[:subestatus] != ''
  @productos = @productos.where("sub_estatus.descripcion like :search", search: "%#{params[:subestatus]}%" )
end

if params[:fecha_retiro] != ''
   @productos = @productos.where("productos_retirados.fecha_retiro like :search", search: "%#{params[:fecha_retiro]}%" )
end

productos = Array.new
productos = [["Tipo GTIN", "GTIN", "Descripción", "Marca",  "Código Producto", "Fecha Creación", "Sub Estatus", "Motivo Retiro", "Fecha Retiro"]]

@productos.each do |producto|

  fecha = ""
  fecha =  producto.fecha_creacion.strftime("%Y-%m-%d") if (producto.fecha_creacion)
  fecha_retiro = (producto.productos_retirados) ? producto.productos_retirados.fecha_retiro.strftime("%Y-%m-%d") : ""
  productos << [producto.try(:tipo_gtin).try(:tipo), producto.gtin,producto.descripcion, producto.marca,  producto.codigo_prod, fecha,  producto.try(:productos_retirados).try(:sub_estatus).try(:descripcion), producto.try(:productos_retirados).try(:motivo_retiro).try(:descripcion),  fecha_retiro ]
end

image "#{Rails.root}/app/assets/images/gs1-logohome", :width => 200, :height => 50
draw_text "#{@empresa.nombre_empresa}", :size => 8, :at => [380,735]
draw_text "Productos Retirados", :size => 8, :at => [380,720]
draw_text "Fecha:#{Time.now}", :size => 8, :at => [380,705]
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(productos,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,80,80,70,45,40])
