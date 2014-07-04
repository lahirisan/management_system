 if params[:servicio] != ''
  @empresa_servicios = @empresa_servicios.where("servicios.nombre like :search", search: "%#{params[:servicio]}%" )
end

if params[:fecha_contratacion] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios_eliminado.fecha_contratacion like :search", search: "%#{params[:fecha_contratacion]}%" )
end

if params[:fecha_finalizacion] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios_eliminado.fecha_finalizacion like :search", search: "%#{params[:fecha_finalizacion]}%" )
end

if params[:nombre_contacto] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios_eliminado.nombre_contacto like :search", search: "%#{params[:nombre_contacto]}%" )
end

if params[:cargo_contacto] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios_eliminado.cargo_contacto like :search", search: "%#{params[:cargo_contacto]}%")
end

if params[:telefono] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios_eliminado.telefono like :search", search: "%#{params[:telefono]}%" )
end

if params[:correo] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios_eliminado.email like :search", search: "%#{params[:correo]}%" )
end

if params[:subestatus] != ''
  @empresa_servicios = @empresa_servicios.where("sub_estatus.descripcion like :search", search: "%#{params[:subestatus]}%" )
end

if params[:motivo_retiro] != ''
  @empresa_servicios = @empresa_servicios.where("motivo_retiro.descripcion like :search", search: "%#{params[:motivo_retiro]}%" )
end

if params[:fecha_eliminacion] != ''
  @empresa_servicios = @empresa_servicios.where("empresa_servicios_eliminado.fecha_eliminacion like :search", search: "%#{params[:fecha_eliminacion]}%" )
end

servicios_eliminados = Array.new
servicios_eliminados = [["Empresa", "Servicio", "Fecha Contratación", "Fecha Finalización", "Nombre Contacto",  "Cargo", "Teléfono", "Correo", "Sub Estatus", "Motivo Retiro", "Fecha Eliminación"]]

@empresa_servicios.each do |empresa_servicio_eliminado| 
 servicios_eliminados <<  [@empresa.nombre_empresa, empresa_servicio_eliminado.servicio.nombre, empresa_servicio_eliminado.fecha_contratacion.strftime("%Y-%m-%d"), empresa_servicio_eliminado.fecha_finalizacion.strftime("%Y-%m-%d"), empresa_servicio_eliminado.nombre_contacto, empresa_servicio_eliminado.cargo_contacto, empresa_servicio_eliminado.telefono, empresa_servicio_eliminado.email, empresa_servicio_eliminado.try(:sub_estatus).try(:descripcion), empresa_servicio_eliminado.try(:motivo_retiro).try(:descripcion), empresa_servicio_eliminado.fecha_eliminacion.strftime("%Y-%m-%d")] 
end

image "#{Rails.root}/app/assets/images/gs1-logohome", :width => 200, :height => 50
draw_text "#{@empresa.nombre_empresa}", :size => 8, :at => [380,735]
draw_text "Servicios Eliminados", :size => 8, :at => [380,720]
draw_text "Fecha:#{Time.now}", :size => 8, :at => [380,705]
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(servicios_eliminados,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,80,80,70,45,40])