pdf.text_box "<b>#{@empresa.nombre_empresa.strip}</b>", :size => 8, :at => [-35,110], :height => 30, :width => 350, :align => :justify,  :inline_format => true
pdf.text_box "<b>Contacto: #{@empresa.rep_ean.strip.upcase}</b>", :size => 7, :at => [-35,100],  :align => :left, :inline_format => true
pdf.text_box "<b>Cargo: #{@empresa.rep_ean_cargo.strip}</b>", :size => 7, :at => [-35,93], :align => :left, :inline_format => true
pdf.text_box "<b>Dirección: #{@empresa.direccion_ean.strip}</b>", :size => 7, :at => [-35,86], :height => 50, :width => 270, :align => :justify, :inline_format => true
pdf.text_box "<b>Pto Ref: #{@empresa.try(:punto_ref_ean)}</b>", :size => 7, :at => [-35,70], :align => :left, :inline_format => true
pdf.text_box "<b>Estado: #{@empresa.try(:estado).try(:nombre)}</b>    Ciudad: <b>#{@empresa.try(:ciudad).try(:nombre).upcase}<b>", :size => 7, :at => [-35,63], :align => :left, :inline_format => true 
pdf.text_box "<b>Municipio: #{@empresa.try(:municipio).try(:nombre)}</b>                                 Prefijo:<b>#{@empresa.prefijo}</b>", :size => 7, :at => [-35,56], :align => :left, :inline_format => true 
pdf.text_box "<b>Parroquia: #{@empresa.try(:parroquia_ean)}</b>", :size => 7, :at => [-35,49], :align => :left, :inline_format => true 
pdf.text_box "<b>Cod Postal: #{@empresa.try(:cod_postal_ean).strip}</b>", :size => 7, :at => [-35,42],  :align => :left, :inline_format => true 
pdf.text_box "<b>Teléfono: #{@telefono}</b>", :size => 7, :at => [-35,35],  :align => :left, :inline_format => true 

