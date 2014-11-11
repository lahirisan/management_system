pdf.text_box "<b>#{@empresa.nombre_empresa.strip}</b>", :size => 11, :at => [-20,150], :height => 30, :width => 350, :align => :justify,  :inline_format => true
pdf.text_box "Contacto: <b>#{@empresa.rep_ean.strip.upcase}", :size => 9, :at => [-20,135],  :align => :left, :inline_format => true
pdf.text_box "Cargo: <b>#{@empresa.rep_ean_cargo.strip.upcase}", :size => 9, :at => [-20,125], :align => :left, :inline_format => true
pdf.text_box "Dirección: <b>#{@empresa.direccion_ean.strip.upcase}", :size => 9, :at => [-20,115], :height => 50, :width => 270, :align => :justify, :inline_format => true
pdf.text_box "Pto Ref: <b>#{@empresa.try(:punto_ref_ean).upcase}", :size => 9, :at => [-20,92], :align => :left, :inline_format => true
pdf.text_box "Estado: <b>#{@empresa.try(:estado).try(:nombre).upcase}</b>    Ciudad: <b>#{@empresa.try(:ciudad).try(:nombre).upcase}<b>", :size => 9, :at => [-20,82], :align => :left, :inline_format => true 
pdf.text_box "Municipio: <b>#{@empresa.try(:municipio).try(:nombre)}<b>", :size => 9, :at => [-20,72], :align => :left, :inline_format => true 
pdf.text_box "Parroquia: <b>#{@empresa.try(:parroquia_ean)}<b>", :size => 9, :at => [-20,62], :align => :left, :inline_format => true 
pdf.text_box "Cod Postal: <b>#{@empresa.try(:cod_postal_ean).strip}<b>", :size => 9, :at => [-20,52],  :align => :left, :inline_format => true 
pdf.text_box "Teléfono: <b>#{@telefono}</b>", :size => 9, :at => [-20,42],  :align => :left, :inline_format => true 

