 #encoding: UTF-8
class ReporteProductosPdf < Prawn::Document	
	

	def initialize(nombre_empresa, prefijo, tipo_gtin, gtin, descripcion,marca, codigo_producto, fecha_creacion, fecha_modificacion, estatus, filtro_general)

		super(:top_margin => 10, :page_layout => :landscape)
 		
 		productos = Producto.joins(:estatus, :tipo_gtin, :empresa).select("empresa.nombre_empresa as nombre_empresa, empresa.prefijo as prefijo, tipo_gtin.tipo as tipo_gtin_, producto.gtin as gtin, producto.marca as marca,  producto.descripcion as descripcion, producto.codigo_prod as codigo_producto, producto.fecha_creacion as fecha_creacion,  estatus.descripcion as estatus_").order("empresa.prefijo")

 		#productos = productos.where("empresa.nombre_empresa like '%#{filtro_general}%' or empresa.prefijo = #{filtro_general} or estatus.descripcion like '%#{filtro_general}%' or tipo_gtin.tipo like '%#{filtro_general}%' or producto.gtin like '%#{filtro_general}%' or producto.descripcion like '%#{filtro_general}%' or producto.marca like '%#{filtro_general}%' or CONVERT(varchar(255),  producto.fecha_creacion ,126) like '%#{filtro_general}%' or CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like '%#{filtro_general}%'") if filtro_general != ''
		productos = productos.where("empresa.nombre_empresa like :search", search: "%#{nombre_empresa}%") if nombre_empresa != ''
		productos = productos.where("empresa.prefijo like :search", search: "%#{prefijo}%") if prefijo != ''
		productos = productos.where("estatus.descripcion like :search", search: "%#{estatus}%") if estatus != ''
		productos = productos.where("tipo_gtin.tipo like :search", search: "%#{tipo_gtin}%") if tipo_gtin != ''
		productos = productos.where("producto.gtin like :search", search: "%#{gtin}%" ) if [:gtin] != ''
		productos = productos.where("producto.descripcion like :search", search: "%#{descripcion}%" ) if descripcion != ''
		productos = productos.where("producto.marca like :search", search: "%#{marca}%" ) if marca != ''
		productos = productos.where("producto.codigo_prod like :search", search: "%#{codigo_producto}%" ) if codigo_producto != ''
		productos = productos.where("CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search", search: "%#{fecha_creacion}%") if fecha_creacion != ''
		productos = productos.where("CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like :search", search: "%#{fecha_modificacion}%") if fecha_modificacion != ''


		

		font("#{Rails.root}/fonts/arial.ttf", :size => 10) do

			productos_arreglo = [["EMPRESA", "PREFIJO", "TIPO GTIN", "GTIN", "MARCA", "DESCRIPCION", "COD", "ESTATUS", "FECHA CREACION"]]


			productos.each do |producto| 
			  productos_arreglo << [producto.nombre_empresa, producto.prefijo, producto.tipo_gtin_, producto.gtin, producto.marca, producto.descripcion, producto.codigo_producto, producto.estatus_, producto.fecha_creacion.strftime("%Y-%m-%d")]

			end

			

			text ""
			move_down 10
			text "Fecha del Reporte:      #{Time.now.strftime("%d/%m/%Y")}", :size => 9, :align => :right


			move_down 30
			text ""
			text "Reporte General Productos", :size => 12, :align => :center

			image "#{Rails.root}/app/assets/images/Gs1Vzla.png", :at => [0, 750], :height => 40

			#number_pages "Pagina <page> de <total>", :size => 9, :at => [480, 720]
			move_down 10
			 table(productos_arreglo,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8, :align => :center }, :header => true, :position => :center)
				move_down 10
			 text "Total productos: #{productos.size}", :size => 9, :align => :left
		end
		
	end

end