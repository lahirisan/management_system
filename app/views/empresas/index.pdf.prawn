@empresas = @empresas.where("prefijo like :search", search: "%#{params[:prefijo]}%") if (params[:prefijo] != '')
@empresas = @empresas.where("nombre_empresa like :search", search: "%#{params[:nombre_empresa]}%") if (params[:nombre_empresa] != '')
@empresas = @empresas.where("fecha_activacion like :search", search: "%#{params[:fecha_activacion]}%") if (params[:fecha_activacion] != '')
@empresas = @empresas.where("ciudad.nombre like :search", search: "%#{params[:ciudad]}%") if (params[:ciudad] != '')
@empresas = @empresas.where("empresa.rif like :search", search: "%#{params[:rif]}%")  if (params[:rif] != '')
@empresas = @empresas.where("sub_estatus.descripcion like :search", search: "%#{params[:sub_estatus]}%")  if (params[:sub_estatus] != '')


empresas = Array.new
empresas = [["Prefijo", "Nombre Empresa", "Fecha Activación", "Ciudad", "RIF", "Estatus", "Sub Estatus", "Clasificación", "Categoría", "División", "Grupo", "Clase"]]

@empresas.each do |empresa|
	fecha =   empresa.fecha_activacion.nil? ? "" : empresa.fecha_activacion.strftime("%Y-%m-%d")
	empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.ciudad.nombre,empresa.rif, empresa.estatus.descripcion, empresa.try(:sub_estatus).try(:descripcion), empresa.try(:clasificacion).try(:descripcion), empresa.try(:categoria), empresa.try(:division), empresa.try(:grupo), empresa.try(:clase) ]
	
 end

draw_text "Empresas Activas", :size => 10, :at => [0,560]
draw_text "Fecha: #{Time.now.strftime("%Y-%m-%d")}", :size => 10, :at => [0,545]
move_down 40
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,40])











 



 