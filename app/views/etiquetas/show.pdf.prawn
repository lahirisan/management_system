pdf.text_box "<b>#{@empresa.nombre_empresa.strip}</b>", :size => 11, :at => [-30,125], :height => 30, :width => 350, :align => :justify,  :inline_format => true
pdf.text_box "Contacto: <b>#{@empresa.rep_ean.strip.upcase}</b>", :size => 9, :at => [-30,110],  :align => :left, :inline_format => true
pdf.text_box "Cargo: <b>#{@empresa.rep_ean_cargo.strip.upcase}</b>", :size => 9, :at => [-30,100], :align => :left, :inline_format => true
pdf.text_box "Dirección: <b>#{@empresa.direccion_ean.strip.upcase}</b>", :size => 9, :at => [-30,90], :height => 50, :width => 270, :align => :justify, :inline_format => true
pdf.text_box "Pto Ref: <b>#{@empresa.try(:punto_ref_ean).upcase}</b>", :size => 9, :at => [-30,70], :align => :left, :inline_format => true
pdf.text_box "Estado: <b>#{@empresa.try(:estado).try(:nombre).upcase}</b>    Ciudad: <b>#{@empresa.try(:ciudad).try(:nombre).upcase}<b>", :size => 9, :at => [-30,50], :align => :left, :inline_format => true 
pdf.text_box "Municipio: <b>#{@empresa.try(:municipio).try(:nombre)}</b>                                 Prefijo:<b>#{@empresa.prefijo}</b>", :size => 9, :at => [-30,40], :align => :left, :inline_format => true 
pdf.text_box "Parroquia: <b>#{@empresa.try(:parroquia_ean)}</b>", :size => 9, :at => [-30,30], :align => :left, :inline_format => true 
pdf.text_box "Cod Postal: <b>#{@empresa.try(:cod_postal_ean).strip}</b>", :size => 9, :at => [-30,20],  :align => :left, :inline_format => true 
pdf.text_box "Teléfono: <b>#{@telefono}</b>", :size => 9, :at => [-30,10],  :align => :left, :inline_format => true 

