 #encoding: UTF-8
class EtiquetaPdf < Prawn::Document	
	
	def initialize(empresa, telefono)
		super(:page_layout => :portrait, :page_size => [355, 185])

		font("#{Rails.root}/fonts/arial.ttf", :size => 8) do

			draw_text "#{empresa.nombre_empresa.strip}", :at  => [-25,135]
			draw_text "Contacto #{empresa.rep_ean.strip.upcase}", :at => [-25,127]
			draw_text "Cargo #{empresa.rep_ean_cargo.strip}", :at => [-25,119]
			draw_text "#{empresa.direccion_ean.strip}", :at => [-25,111]
			draw_text "Pto Ref #{empresa.try(:punto_ref_ean)}", :at => [-25,103]
			draw_text "Estado #{empresa.try(:estado).try(:nombre)}  Ciudad #{empresa.try(:ciudad).try(:nombre).upcase}  Parroquia #{empresa.try(:parroquia_ean)}" , :at => [-25,95]
			draw_text "Municipio #{empresa.try(:municipio).try(:nombre)}                                Prefijo #{empresa.prefijo}", :at => [-25,87]
			draw_text "Cod Postal #{empresa.try(:cod_postal_ean).strip}                      Telefono #{telefono} ", :at => [-25,79]
			
			
		end
		
	end

end
