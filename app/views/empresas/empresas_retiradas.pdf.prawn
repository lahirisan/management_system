if params[:prefijo] != ''
   @empresas = @empresas.where("empresa.prefijo like :search", search: "%#{params[:prefijo]}%" )
end
if params[:nombre_empresa] != ''
  @empresas = @empresas.where("empresa.nombre_empresa like :search", search: "%#{params[:nombre_empresa]}%" )
end

if params[:fecha_inscripcion] != ''
  @empresas = @empresas.where("empresa.fecha_inscripcion like :search", search: "%#{params[:fecha_inscripcion]}%" )
end
if params[:ciudad] != ''
  @empresas = @empresas.where("ciudad.nombre like :search", search: "%#{params[:ciudad]}%" )
end

if params[:rif] != ''
   @empresas = @empresas.where("empresa.rif like :search", search: "%#{params[:rif]}%" )
end

if params[:fecha_retiro] != ''
   @empresas = @empresas.where("empresas_retiradas.fecha_retiro like :search", search: "%#{params[:fecha_retiro]}%" )
end

if params[:subestatus] != ''
   @empresas = @empresas.where("sub_estatus.descripcion like :search", search: "%#{params[:subestatus]}%" )
end

if params[:motivo_retiro] != ''
   @empresas = @empresas.where("motivo_retiro.descripcion like :search", search: "%#{params[:motivo_retiro]}%" )
end


empresas = Array.new
empresas = [["Prefijo", "Nombre Empresa", "Fecha Inscripción", "Ciudad", "RIF", "Estatus",  "Sub Estatus", "Motivo Retiro", "Clasificación", "Categoría", "División", "Grupo", "Clase"]]

@empresas.each do |empresa|
	fecha =   empresa.fecha_inscripcion.nil? ? "" : empresa.fecha_inscripcion.strftime("%Y-%m-%d")
	empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.ciudad.nombre,empresa.rif, empresa.estatus.descripcion, empresa.try(:empresas_retiradas).try(:sub_estatus).try(:descripcion),empresa.try(:empresas_retiradas).try(:motivo_retiro).try(:descripcion), empresa.try(:clasificacion).try(:descripcion), empresa.try(:categoria), empresa.try(:division), empresa.try(:grupo), empresa.try(:clase) ]
	
 end

image "#{Rails.root}/app/assets/images/gs1-logohome", :width => 200, :height => 50
draw_text "Empresas Retiradas", :size => 10, :at => [500,540]
draw_text "Fecha:#{Time.now}", :size => 10, :at => [500,525]
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,40])



