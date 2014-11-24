 fecha = Time.now
 @empresas.each do |empresa|

  image "#{Rails.root}/app/assets/images/Gs1Vzla.png", :at => [0, 720], :height => 50
  draw_text "Caracas #{Time.now.strftime("%d-%m-%Y")}", :size => 10, :at => [390,655]
  draw_text "Señores.-", :size => 10, :at => [0,640]
  draw_text "#{empresa.nombre_empresa.strip}", :size => 10, :at => [0,625]
  draw_text "Presente.-", :size => 10, :at => [0,610]
  draw_text "Estimado Sr(a).   #{empresa.rep_legal}", :size => 10, :at => [0,595], :inline_format => :true
  

  text_box "Me dirijo a Ud. en la oportunidad de informarle, para su conocimento y fines consiguentes, que  el Consejo Directivo de la Asociación para la Codificación Internacional de Productos de Venezuela ha procedio a desafiliar a la Empresa #{empresa.nombre_empresa.strip} que Ud. representa, identificada con el Prefijo de Compañía #{empresa.prefijo}, retirándola de la base de datos; por haber incumplido con el Artículo 10, Literal C, de los Estatutos de la Asociación.", :size => 10, :at => [0,545], :width => 500, :align => :justify
  text_box "Dicha desafiliación implica las siguentes consecuencias:",  :size => 10, :at => [0,475],  :align => :left
  text_box "1.- A partir de la presente fecha todos los productos identificados con el prefijo #{empresa.prefijo}, deberán ser retirados del mercado de acuerdo a lo establecido en los Estatutos de la Asociación.", :size => 10, :at => [50,450], :width => 450, :align => :justify
  text_box "2.- La Asociación se reserva el derecho de asignar el prefijo a otra Empresa. Esto podría ocasionar, en caso de no tomar las medidas establecidas en el punto 1, la presencia, en la cadena de comercialización, de productos diferentes con el mismo código de barras.", :size => 10, :at => [50,420], :width => 450, :align => :justify
  
  text_box "En tal sentido, adjunto le envío un listado de los productos identificados con el prefijo #{empresa.prefijo}, los cuales seran eliminados de nuestra base de datos e informaremos a todos los puntos de ventas del mencionado retiro, par así dar cumplimento a lo expuesto en la presente comunicación.", :size => 10, :at => [0,360], :width => 500, :align => :justify
  

  draw_text "Atentamente,", :size => 10, :at => [0,250]

  draw_text "José Luis Mejía Nuñez", :size => 10, :at => [0,180]
  draw_text "Presidente Ejecutivo", :size => 10, :at => [0,165]
  draw_text "GS1 Venezuela", :size => 10, :at => [0,150]

  draw_text "Avenida Francisco de Miranda Calle", :size => 7, :at => [350,120]
  draw_text "Los Laboratorios Centro Empresarial", :size => 7, :at => [350,110]
  draw_text "Quorum, piso 1, Ofic. J y K,", :size => 7, :at => [350,100] 
  draw_text "Los Ruices, Caracas - 1071 ", :size => 7, :at => [350,90] 
  draw_text "Venezuela", :size => 7, :at => [350,80] 
  draw_text "EC / JLM / MFT / 6#{fecha.strftime("%d%m%Y")}", :size => 8, :at => [0,60]

  pdf.start_new_page

  draw_text "PRODUCTOS CODIFICADOS", :size => 10, :at => [200,700], :style => :bold
  draw_text "Empresa: #{empresa.nombre_empresa}", :size => 9, :at => [150,685]
  draw_text "Código Empresa: #{empresa.prefijo}", :size => 9, :at => [150,675]
  image "#{Rails.root}/app/assets/images/Gs1Vzla.png", :at => [0, 725], :height => 50
  productos = Array.new
  productos = [["MARCA", "DESCRIPCION", "CODIGO", "Tipo de GTIN"]]

  @productos = Producto.find(:all, :conditions => ["prefijo = ?", empresa.prefijo])

  @productos.each do |producto| 
    productos << [ producto.marca, producto.descripcion, producto.gtin, producto.try(:tipo_gtin).try(:tipo)]
  end

  move_down 100
   table(productos,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8, :align => :center }, :column_widths => [150,190,100,100], :header => true, :position => :center)
   move_down 10
   text "<b>Total productos: #{@productos.size}</b>", :size => 10, :align => :left, :inline_format => :true

   pdf.start_new_page
end






