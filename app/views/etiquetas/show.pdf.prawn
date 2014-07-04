# Prawn::Document.generate("page_size.pdf", :page_size => "EXECUTIVE", :page_layout => :landscape ) do
# 	text "EXECUTIVE landscape page."
# 	custom_size = [275, 326]

# 	["A4", "TABLOID", "B7", custom_size ].each do |size|
# 		start_new_page(:size => size, :layout => :portrait)
# 		text "#{size} portrait page."
# 		start_new_page(:size => size, :layout => :landscape)
# 		text "#{size} landscape page."
# 	end
# end

pdf = Prawn::Document.new(:page_size => "EXECUTIVE", :page_layout => :landscape )
pdf.text "Hello World"
pdf.render_file "assignment.pdf"


#pdf.page_layout => :landscape
#pdf.text "#{@etiqueta.empresa.nombre_empresa}"
#draw_text "This draw_text line is absolute positioned. However don't " +
#{}"expect it to flow even if it hits the document border",
#:at => [0, 0]

#items =  [["Contacto","#{@contacto.try(:nombre_contacto)}"], ["Cargo", "#{@contacto.try(:cargo_contacto)}"], ["Telefono","#{@contacto.try(:contacto)}"], ["Edificio", "#{@etiqueta.try(:edificio)}"], ["Calle", "#{@etiqueta.try(:calle)}"], ["Urbanizacion", "#{@etiqueta.try(:urbanizacion)}"], ["Estado", "#{@etiqueta.try(:estado).try(:nombre)}"], ["Ciudad", "#{@etiqueta.try(:ciudad).try(:nombre)}"], ["Municipio","#{@etiqueta.try(:municipio).try(:nombre)}"], ["Parroquia", "#{@etiqueta.try(:parroquia).try(:nombre)}"], ["Código Postal", "#{@etiqueta.try(:cod_postal)}"], ["Punto Referencia", "#{@etiqueta.try(:punto_referencia)}"]]
#pdf.table items, :cell_style => {:border_lines =>[:none]}