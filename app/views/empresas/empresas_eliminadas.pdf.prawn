@empresas = @empresas.where("empresa_eliminada.prefijo like :search", search: "%#{params[:prefijo]}%" )   if params[:prefijo] != ''
@empresas = @empresas.where("empresa_eliminada.nombre_empresa like :search", search: "%#{params[:nombre_empresa]}%" )  if params[:nombre_empresa] != ''
@empresas = @empresas.where("empresa_eliminada.fecha_inscripcion like :search", search: "%#{params[:fecha_inscripcion]}%" )  if params[:fecha_inscripcion] != ''
@empresas = @empresas.where("ciudad.nombre like :search", search: "%#{params[:ciudad]}%" ) if params[:ciudad] != ''
@empresas = @empresas.where("empresa_eliminada.rif like :search", search: "%#{params[:rif]}%" ) if params[:rif] != ''
@empresas = @empresas.where("empresa_elim_detalle.fecha_eliminacion like :search", search: "%#{params[:fecha_eliminacion]}%" ) if params[:fecha_eliminacion] != ''
@empresas = @empresas.where("sub_estatus.descripcion like :search", search: "%#{params[:subestatus]}%" ) if params[:subestatus] != ''
@empresas = @empresas.where("motivo_retiro.descripcion like :search", search: "%#{params[:motivo_retiro]}%" ) if params[:motivo_retiro] != ''

empresas = Array.new
empresas = [["Prefijo", "Nombre Empresa", "Fecha Inscripción", "Ciudad", "RIF", "Estatus", "Fecha Eliminación","Sub Estatus", "Motivo Retiro", "Clasificación", "Categoría", "División", "Grupo", "Clase"]] 

@empresas.each do |empresa|
	fecha =   empresa.fecha_inscripcion.nil? ? "" : empresa.fecha_inscripcion.strftime("%Y-%m-%d")
	fecha_eliminacion = empresa.try(:empresa_elim_detalle).try(:fecha_eliminacion) 
    fecha_eliminacion = (fecha_eliminacion) ? fecha_eliminacion.strftime("%Y-%m-%d") : ""
	empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.try(:ciudad).try(:nombre),empresa.rif, empresa.try(:estatus).try(:descripcion), fecha_eliminacion,  empresa.try(:sub_estatus).try(:descripcion),empresa.try(:motivo_retiro).try(:descripcion), empresa.try(:clasificacion).try(:descripcion), empresa.try(:categoria), empresa.try(:division), empresa.try(:grupo), empresa.try(:clase)]
 end

image "#{Rails.root}/app/assets/images/gs1-logohome", :width => 200, :height => 50
draw_text "Empresas Eliminadas", :size => 10, :at => [500,540]
draw_text "Fecha:#{Time.now}", :size => 10, :at => [500,525]
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,50,50])