 #encoding: UTF-8
class EmpresasRetiradasPdf < Prawn::Document	
	
	def initialize(empresas_)
		
		super(:top_margin => 10, :page_layout => :landscape)
		
		
		empresas = [["Prefijo", "Nombre Empresa", "Fecha Inscripción", "Ciudad", "RIF", "Estatus", "Fecha Retiro", "Sub Estatus", "Motivo Retiro", "Clasificación", "Categoría", "División", "Grupo", "Clase"]]

		empresas_.each do |empresa|
			fecha =   empresa.fecha_inscripcion.nil? ? "" : empresa.fecha_inscripcion.strftime("%Y-%m-%d")
			fecha_retiro = empresa.fecha_retiro.nil? ? "" : empresa.fecha_retiro.strftime("%Y-%m-%d")
			empresas << [empresa.prefijo, empresa.nombre_empresa,fecha, empresa.ciudad.nombre,empresa.rif, empresa.estatus.descripcion, fecha_retiro, empresa.try(:sub_estatus).try(:descripcion),empresa.try(:motivo_retiro).try(:descripcion), empresa.try(:clasificacion).try(:descripcion), empresa.try(:categoria), empresa.try(:division), empresa.try(:grupo), empresa.try(:clase) ]
			
		 end

		font("Helvetica", :size => 10)
		draw_text "Empresas Retiradas", :at => [0,560]
		draw_text "Fecha:#{Time.now.strftime("%Y-%m-%d")}", :at => [0,545]
		move_down 40
		#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
		table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,40])
		
	end

end