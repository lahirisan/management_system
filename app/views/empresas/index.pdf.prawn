@empresas = @empresas.where("estatus.descripcion = ?", 'Activa')  if params[:retirar]
@empresas = @empresas.where("prefijo like :search", search: "%#{params[:prefijo]}%") if (params[:prefijo] != '')
@empresas = @empresas.where("nombre_empresa like :search", search: "%#{params[:nombre_empresa]}%") if (params[:nombre_empresa] != '')
@empresas = @empresas.where("fecha_inscripcion like :search", search: "%#{params[:fecha_inscripcion]}%") if (params[:fecha_inscripcion] != '')
@empresas = @empresas.where("estados.nombre like :search", search: "%#{params[:estado]}%") if (params[:estado] != '')
@empresas = @empresas.where("ciudad.nombre like :search", search: "%#{params[:ciudad]}%") if (params[:ciudad] != '')
@empresas = @empresas.where("empresa.rif like :search", search: "%#{params[:rif]}%")  if (params[:rif] != '')

empresas = Array.new
empresas = [["Prefijo", "Nombre Empresa", "Fecha Inscripción", "Ciudad", "RIF", "Estatus", "Clasificación", "Categoría", "División", "Grupo", "Clase"]]

@empresas.each do |empresa|
	fecha =   empresa.fecha_inscripcion.nil? ? "" : empresa.fecha_inscripcion.strftime("%Y-%m-%d")
	empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.ciudad.nombre,empresa.rif, empresa.estatus.descripcion, empresa.try(:clasificacion).try(:descripcion), empresa.try(:categoria), empresa.try(:division), empresa.try(:grupo), empresa.try(:clase) ]
	
 end

draw_text "Empresas Activas", :size => 10, :at => [0,560]
draw_text "Fecha: #{Time.now.strftime("%Y-%m-%d")}", :size => 10, :at => [0,545]
move_down 40
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,40])











 



 