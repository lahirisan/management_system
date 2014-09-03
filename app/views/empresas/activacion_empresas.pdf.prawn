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
  @empresas = @empresas.where("empresa.rif like :search", search: "%#{params[:ciudad]}%" )
end

empresas = Array.new
empresas = [["Prefijo", "Nombre Empresa", "Fecha Inscripción", "Direcccion Empresa", "Estado", "Ciudad", "RIF", "Estatus"]]

@empresas.each do |empresa|
  fecha =   empresa.fecha_inscripcion.nil? ? "" : empresa.fecha_inscripcion.strftime("%Y-%m-%d")
  empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.direccion_empresa, empresa.try(:estado).try(:nombre), empresa.try(:ciudad).try(:nombre), empresa.rif, empresa.estatus.descripcion]
  
 end

draw_text "Empresas No Validadas", :size => 10, :at => [0,560]
draw_text "Fecha:#{Time.now.strftime("%Y-%m-%d")}", :size => 10, :at => [0,545]
move_down 40
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,40])