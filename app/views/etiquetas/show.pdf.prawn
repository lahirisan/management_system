pdf.text_box "<b>#{@empresa.nombre_empresa.strip}</b>", :size => 8, :at => [-35,120], :height => 30, :width => 350, :align => :justify,  :inline_format => true
pdf.text_box "<b>Contacto: #{@empresa.rep_ean.strip.upcase}</b>", :size => 7, :at => [-35,110],  :align => :left, :inline_format => true
pdf.text_box "<b>Cargo: #{@empresa.rep_ean_cargo.strip}</b>", :size => 7, :at => [-35,103], :align => :left, :inline_format => true
pdf.text_box "<b>Dirección: #{@empresa.direccion_ean.strip}</b>", :size => 7, :at => [-35,96], :height => 50, :width => 270, :align => :justify, :inline_format => true
pdf.text_box "<b>Pto Ref: #{@empresa.try(:punto_ref_ean)}</b>", :size => 7, :at => [-35,80], :align => :left, :inline_format => true
pdf.text_box "<b>Estado: #{@empresa.try(:estado).try(:nombre)}</b>    Ciudad: <b>#{@empresa.try(:ciudad).try(:nombre).upcase}<b>", :size => 7, :at => [-35,73], :align => :left, :inline_format => true 
pdf.text_box "<b>Municipio: #{@empresa.try(:municipio).try(:nombre)}</b>                                 Prefijo:<b>#{@empresa.prefijo}</b>", :size => 7, :at => [-35,66], :align => :left, :inline_format => true 
pdf.text_box "<b>Parroquia: #{@empresa.try(:parroquia_ean)}</b>", :size => 7, :at => [-35,59], :align => :left, :inline_format => true 
pdf.text_box "<b>Cod Postal: #{@empresa.try(:cod_postal_ean).strip}</b>", :size => 7, :at => [-35,52],  :align => :left, :inline_format => true 
pdf.text_box "<b>Teléfono: #{@telefono}</b>", :size => 7, :at => [-35,45],  :align => :left, :inline_format => true 

