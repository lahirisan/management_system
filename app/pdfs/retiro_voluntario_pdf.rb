 #encoding: UTF-8
class RetiroVoluntarioPdf < Prawn::Document	
	
	def initialize(empresa, productos)
		
		super(:top_margin => 10, :page_layout => :portrait)

		font("Helvetica", :size => 10)

		image "#{Rails.root}/app/assets/images/Gs1Vzla.png", :at => [0, 720], :height => 50
		draw_text "Caracas #{Time.now.strftime("%d-%m-%Y")}", :at => [390,655]
		draw_text "Señores.-", :at => [0,640]
		draw_text "#{empresa.nombre_empresa.strip}", :at => [0,625]
		draw_text "Presente.-", :at => [0,580]
		draw_text "Estimado Sr(a).   #{empresa.rep_legal}", :at => [0,565]

		text_box "En atención a su comunicación de dias anteriores, me dirijo a usted en la oportunidad de informarle, para su conocimiento y fines consiguientes que, la Asociación para la Codificación Internacional de Productos GS1 Venezuela ha procedido de acuerdo a su solicitud, a desafiliar a la empresa #{empresa.nombre_empresa.strip} identificada con el prefijo de compañía #{empresa.prefijo}, de la base de datos; implicando dicha desafiliación las siguientes consecuencias:",  :at => [10,535], :width => 500, :align => :justify
		text_box "1.- A partir de la presente fecha todos los productos identificados con el prefijo #{empresa.prefijo}, deberán ser retirados del mercado de acuerdo a lo establecido en los Estatutos de la Asociación.", :at => [50,470], :width => 450, :align => :justify
		text_box "2.- La Asociación se reserva el derecho de asignar el prefijo a otra Empresa en un tiempo  determinado.",  :at => [50,440], :width => 450, :align => :justify
		text_box "3.- GS1 Venezuela realizará las gestiones pertinentes ante los puntos de ventas correspondientes, con el fin de notificarles el retiro de los productos de #{empresa.nombre_empresa.strip} codificados bajo el Sistema de Identificación GS1.",  :at => [50,410], :width => 450, :align => :justify
		text_box "4.- Si en un futuro surgiera el interés de ingresar nuevamente al Sistema de Codificación GS1, #{empresa.nombre_empresa.strip} deberá solicitar su afiliación ante la Asociación y cumplir con cada uno de los requisitos exigidos.", :at => [50,370], :width => 450, :align => :justify
		text_box "En tal sentido y con el propósito de facilitar el proceso de desafiliación de la empresa adjunto le envío el listado de los productos codificados en nuestra base de datos con el fin de dar cumplimiento al punto uno expuesto en el presente documento. ",  :at => [10,320], :width => 500, :align => :justify
		text_box "Lamentando su decisión de no continuar como miembro de GS1 Venezuela y quedando a su disposición para cualquier información que tenga a bien solicitar, se despide de usted,",  :at => [10,270], :width => 500, :align => :justify

		draw_text "Atentamente",  :at => [10,200]


		draw_text "Jose Luis Mejia N.",  :at => [10,150]
		draw_text "Presidente Ejecutivo",  :at => [10,135]
		draw_text "GS1 Venezuela",  :at => [10,120]

		font("Helvetica", :size => 7)
		draw_text "Avenida Francisco de Miranda Calle", :at => [350,120]
		draw_text "Los Laboratorios Centro Empresarial",  :at => [350,110]
		draw_text "Quorum, piso 1, Ofic. J y K,",  :at => [350,100] 
		draw_text "Los Ruices, Caracas - 1071 ", :at => [350,90] 
		draw_text "Venezuela", :at => [350,80] 
		draw_text "T +58 (212) 237 87 77", :at => [350,70] 
		draw_text "  +58 (212) 237 95 20", :at => [350,60] 
		draw_text "F +58 (212) 237 72 50", :at => [350,50]
		draw_text "E info@gs1ve.org",  :at => [350,40]
		draw_text "GT / JLM / MFT / 6170914", :size => 8, :at => [10,60]

		start_new_page

		font("Helvetica", :size => 9)
		draw_text "PRODUCTOS CODIFICADOS", :size => 10, :at => [200,700], :style => :bold
		draw_text "Empresa: #{empresa.nombre_empresa}",  :at => [150,685]
		draw_text "Código Empresa: #{empresa.prefijo}",  :at => [150,675]
		image "#{Rails.root}/app/assets/images/Gs1Vzla.png", :at => [0, 725], :height => 50
		
		tabla_productos = [["MARCA", "DESCRIPCION", "CODIGO", "Tipo de GTIN"]]

		productos.each do |producto| 
		  tabla_productos << [ producto.marca, producto.descripcion, producto.gtin, producto.try(:tipo_gtin).try(:tipo)]
		end
		move_down 100
		 table(tabla_productos,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8, :align => :center }, :column_widths => [150,190,100,100], :header => true, :position => :center)
		 move_down 10
		 text "<b>Total productos: #{productos.size}</b>", :size => 10, :align => :left, :inline_format => :true
		
	end

end