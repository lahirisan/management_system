
	

	empresas = Array.new
  	@empresas.each do |empresa|
    fecha = ""
    fecha =  empresa.fecha_inscripcion.strftime("%Y-%m-%d") if (empresa.fecha_inscripcion)
    #empresas << [empresa.prefijo, empresa.nombre_empresa,fecha,empresa.direccion_empresa,empresa.estado.nombre,empresa.ciudad.nombre,empresa.rif,empresa.estatus.descripcion,empresa.id_tipo_usuario,empresa.nombre_comercial,empresa.id_clasificacion,empresa.categoria,empresa.division,empresa.grupo,empresa.clase,empresa.rep_legal,empresa.cargo_rep_legal]
    empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.estado.nombre,empresa.rif, empresa.estatus.descripcion]
  end
 
  table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"],  :border_style => :grid)







 



 