#  #encoding: UTF-8
# class EmpresasRetiradasPdf < Prawn::Document	
	
# 	def initialize(empresas, parametros)
		
# 		super(:top_margin => 10, :page_layout => :landscape)
		
# 		if parametros[:prefijo] != ''
# 		   empresas = empresas.where("empresa.prefijo like :search", search: "%#{parametros[:prefijo]}%" )
# 		end
# 		if parametros[:nombre_empresa] != ''
# 		  empresas = empresas.where("empresa.nombre_empresa like :search", search: "%#{parametros[:nombre_empresa]}%" )
# 		end

# 		if parametros[:fecha_inscripcion] != ''
# 		  empresas = empresas.where("empresa.fecha_inscripcion like :search", search: "%#{parametros[:fecha_inscripcion]}%" )
# 		end
# 		if parametros[:ciudad] != ''
# 		  empresas = empresas.where("ciudad.nombre like :search", search: "%#{parametros[:ciudad]}%" )
# 		end

# 		if parametros[:rif] != ''
# 		   empresas = empresas.where("empresa.rif like :search", search: "%#{parametros[:rif]}%" )
# 		end

# 		if parametros[:fecha_retiro] != ''
# 		   empresas = empresas.where("empresas_retiradas.fecha_retiro like :search", search: "%#{parametros[:fecha_retiro]}%" )
# 		end

# 		if parametros[:subestatus] != ''
# 		   empresas = empresas.where("sub_estatus.descripcion like :search", search: "%#{parametros[:subestatus]}%" )
# 		end

# 		if parametros[:motivo_retiro] != ''
# 		   empresas = empresas.where("motivo_retiro.descripcion like :search", search: "%#{parametros[:motivo_retiro]}%" )
# 		end

		
# 		empresas = [["Prefijo", "Nombre Empresa", "Fecha Inscripción", "Ciudad", "RIF", "Estatus",  "Sub Estatus", "Motivo Retiro", "Clasificación", "Categoría", "División", "Grupo", "Clase"]]

# 		empresas.each do |empresa|
# 			fecha =   empresa.fecha_inscripcion.nil? ? "" : empresa.fecha_inscripcion.strftime("%Y-%m-%d")
# 			empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.ciudad.nombre,empresa.rif, empresa.estatus.descripcion, empresa.try(:empresas_retiradas).try(:sub_estatus).try(:descripcion),empresa.try(:empresas_retiradas).try(:motivo_retiro).try(:descripcion), empresa.try(:clasificacion).try(:descripcion), empresa.try(:categoria), empresa.try(:division), empresa.try(:grupo), empresa.try(:clase) ]
			
# 		 end

# 		font("Helvetica", :size => 10)
# 		draw_text "Empresas Retiradas", :at => [0,560]
# 		draw_text "Fecha:#{Time.now.strftime("%Y-%m-%d")}", :at => [0,545]
# 		move_down 40
# 		#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
# 		table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,40])
		
# 	end

# end