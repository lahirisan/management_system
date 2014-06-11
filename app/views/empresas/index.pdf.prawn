
empresas = Array.new
empresas = [["Prefijo", "Nombre Empresa", "Fecha Inscripción", "Ciudad", "RIF", "Estatus", "Clasificación", "Categoría", "División", "Grupo", "Clase"]]
@empresas.each do |empresa|
 	fecha =   empresa.fecha_inscripcion.nil? ? "" : empresa.fecha_inscripcion.strftime("%Y-%m-%d")
 	empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.ciudad.nombre,empresa.rif, empresa.estatus.descripcion, empresa.try(:clasificacion).try(:descripcion), empresa.try(:clasificacion).try(:categoria), empresa.try(:clasificacion).try(:division), empresa.try(:clasificacion).try(:grupo), empresa.try(:clasificacion).try(:clase) ]
 end

image "#{Rails.root}/app/assets/images/gs1-logohome", :width => 200, :height => 50
draw_text "Listado Empresas", :size => 10, :at => [500,540]
draw_text "Fecha:#{Time.now}", :size => 10, :at => [500,525]
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [47,100,50,70,65,40])











 



 