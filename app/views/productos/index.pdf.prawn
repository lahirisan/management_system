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
  @productos = @productos.where("CONVERT(varchar(255),  producto.fecha_creacion ,126) like '%#{params[:fecha_creacion]}%'")
	
end

if params[:fecha_modificacion] != ''
  
  @productos = @productos.where("CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like '%#{params[:fecha_modificacion]}%'")
end

productos = Array.new
productos = [["MARCA", "DESCRIPCION", "CODIGO", "TIPO CODIGO"]]

@productos.each do |producto| 
  
  productos << [ producto.marca, producto.descripcion, producto.gtin, producto.try(:tipo_gtin).try(:tipo)]
end

text ""
move_down 10
text "Fecha del Reporte:      #{Time.now.strftime("%d/%m/%Y")}", :size => 9, :align => :right


move_down 30
text ""
text "#{@empresa.nombre_empresa.strip}", :size => 12, :align => :center

image "#{Rails.root}/app/assets/images/Gs1Vzla.png", :at => [0, 750], :height => 40

#number_pages "Pagina <page> de <total>", :size => 9, :at => [480, 720]
move_down 10
 table(productos,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8, :align => :center }, :column_widths => [150,190,100,100], :header => true, :position => :center)
	move_down 10
 text "Total productos: #{@productos.size}", :size => 9, :align => :left


#repeat :all do
    # header

    #bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      #  font "Helvetica"
      #  text "Here's My Fancy Header", :align => :center, :size => 25
       # stroke_horizontal_rule
      
        
    #end
    

    # footer
    #bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
     #   font "Helvetica"
        #stroke_horizontal_rule
      #  move_down(5)
      #  text "And here's a sexy footer", :size => 16
    #end


 # end

  