 #encoding: UTF-8
class EtiquetaPdf < Prawn::Document	
	
	def initialize(empresa)
		super(:page_layout => :portrait, :page_size => [285, 170])

		font("Helvetica", :size => 8, :style => :bold) # Tipos de fuente: "Courier", "Helvetica", "Times-Roman"

		draw_text "#{empresa.nombre_empresa.strip}", :at  => [-35,110]
		draw_text "Contacto: #{empresa.rep_ean.strip.upcase}", :at => [-35,100]
		draw_text "Cargo: #{empresa.rep_ean_cargo.strip}", :at => [-35,93]
		draw_text "Dirección: #{empresa.direccion_ean.strip}", :at => [-35,86]
		draw_text "Pto Ref: #{empresa.try(:punto_ref_ean)}", :at => [-35,70]
		draw_text "Estado: #{empresa.try(:estado).try(:nombre)}    Ciudad: #{empresa.try(:ciudad).try(:nombre).upcase}" , :at => [-35,63]
		draw_text "Municipio: #{empresa.try(:municipio).try(:nombre)}                                 Prefijo: #{empresa.prefijo}", :at => [-35,56]
		draw_text "Parroquia: #{empresa.try(:parroquia_ean)}", :at => [-35,49]
		draw_text "Cod Postal: #{empresa.try(:cod_postal_ean).strip}", :at => [-35,42]
		draw_text "Teléfono: #{@telefono}", :at => [-35,35]
		
	end

end