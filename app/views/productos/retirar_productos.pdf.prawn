if params[:tipo_gtin] != ''
  @productos = @productos.where("tipo_gtin.tipo like :search", search: "%#{params[:tipo_gtin]}%" )
end

if params[:gtin] != ''
  @productos = @productos.where("producto.gtin like :search", search: "%#{params[:gtin]}%" )
end

if params[:descripcion] != ''
  @productos = @productos.where("producto.descripcion like :search", search: "%#{params[:descripcion]}%" )
end

if params[:marca] != ''
  @productos = @productos.where("producto.marca like :search", search: "%#{params[:marca]}%" )
end

if params[:gpc] != ''
  @productos = @productos.where("producto.gpc like :search", search: "%#{params[:gpc]}%" )
end


if params[:codigo_producto] != ''
  @productos = @productos.where("producto.codigo_prod like :search", search: "%#{params[:codigo_producto]}%" )
end

productos = Array.new
productos = [["Tipo GTIN", "GTIN", "Descripción", "Marca", "GPC", "Estatus", "Código Producto", "Fecha Creación"]]

@productos.each do |producto|
  fecha =   producto.fecha_creacion.nil? ? "" : producto.fecha_creacion.strftime("%Y-%m-%d")
  productos << [ producto.try(:tipo_gtin).try(:tipo), producto.gtin,producto.descripcion, producto.marca, producto.gpc,producto.try(:estatus).try(:descripcion), producto.codigo_prod, fecha]
end

image "#{Rails.root}/app/assets/images/gs1-logohome", :width => 200, :height => 50
draw_text "#{@empresa.nombre_empresa}", :size => 8, :at => [380,735]
draw_text "Listado General de productos", :size => 8, :at => [380,720]
draw_text "Fecha:#{Time.now}", :size => 8, :at => [380,705]
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(productos,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,80,80,70,45,40])
