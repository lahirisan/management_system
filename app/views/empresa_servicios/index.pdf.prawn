if params[:servicio] != ''
  @empresa_servicios = @empresa_servicios.where("servicios.nombre like :search", search: "%#{params[:servicio]}%" )
end

if params[:fecha_contratacion] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios.fecha_contratacion like :search", search: "%#{params[:fecha_contratacion]}%" )
end

if params[:fecha_finalizacion] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios.fecha_finalizacion like :search", search: "%#{params[:fecha_finalizacion]}%" )
end

if params[:nombre_contacto] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios.nombre_contacto like :search", search: "%#{params[:nombre_contacto]}%" )
end

if params[:cargo_contacto] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios.cargo_contacto like :search", search: "%#{params[:cargo_contacto]}%" )
end

if params[:telefono] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios.telefono like :search", search: "%#{params[:telefono]}%" )
end

if params[:correo] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios.email like :search", search: "%#{params[:correo]}%" )
end

servicios = Array.new
servicios = [["Empresa", "Servicio", "Fecha Contratación", "Fecha Finalización", "Nombre Contacto",  "Cargo", "Teléfono", "Correo"]]

@empresa_servicios.each do |servicio| 
	
  servicios << [servicio.empresa.nombre_empresa, servicio.servicio.nombre, servicio.fecha_contratacion.strftime("%Y-%m-%d"), servicio.fecha_finalizacion.strftime("%Y-%m-%d"), servicio.nombre_contacto, servicio.cargo_contacto, servicio.telefono, servicio.email ]

end

image "#{Rails.root}/app/assets/images/gs1-logohome", :width => 200, :height => 50
draw_text "#{@empresa.nombre_empresa}", :size => 8, :at => [380,735]
draw_text "Listado General de Servicios", :size => 8, :at => [380,720]
draw_text "Fecha:#{Time.now}", :size => 8, :at => [380,705]
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(servicios,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,80,80,70,45,40])
