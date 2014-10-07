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
if params[:codigo_producto] != ''
  @productos = @productos.where("producto.codigo_prod like :search", search: "%#{params[:codigo_producto]}%" )
end
if params[:fecha_creacion] != ''
	@productos = @productos.where("CONVERT(DATETIME, FLOOR(CONVERT(FLOAT, producto.fecha_creacion))) = '#{params[:fecha_creacion]}'")
  
end

productos = Array.new
productos = [["Marca", "Descripción", "Código Producto", "Tipo Código"]]

@productos.each do |producto| 
  
  productos << [ producto.marca, producto.descripcion, producto.gtin, producto.try(:tipo_gtin).try(:tipo)]
end

text "Fecha del Reporte:      #{Time.now.strftime("%d/%m/%Y")}", :size => 9, :align => :right
text ""
text ""
text "#{@empresa.nombre_empresa.strip}", :size => 12, :align => :center

#draw_text "Listado Productos Activos", :size => 8, :at => [0,720]

#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(productos,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [150,150,100,100])

