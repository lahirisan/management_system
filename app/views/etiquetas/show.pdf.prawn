pdf.text_box "#{@empresa.nombre_empresa.strip}", :size => 9, :at => [-20,150], :height => 30, :width => 250, :align => :justify, :inline_format => true
pdf.text_box "Contacto: <b>#{@empresa.rep_ean.strip}", :size => 9, :at => [-20,130], :height => 10, :width => 180, :align => :justify, :inline_format => true
pdf.text_box "Cargo: <b>#{@empresa.rep_ean_cargo.strip}", :size => 9, :at => [-20,120], :height => 10, :width => 180, :align => :justify, :inline_format => true
pdf.text_box "Dirección: <b>#{@empresa.direccion_ean.strip}", :size => 9, :at => [-20,110], :height => 50, :width => 250, :align => :justify, :inline_format => true
pdf.text_box "Estado: <b>#{@estado_ean.try(:nombre).strip}", :size => 9, :at => [-20,70], :height => 10, :width => 180, :align => :justify, :inline_format => true if @estado_ean
pdf.text_box "Ciudad: <b>#{@ciudad_ean.try(:nombre).strip}", :size => 9, :at => [-20,60], :height => 10, :width => 180, :align => :justify, :inline_format => true if @ciudad_ean
pdf.text_box "Municipio: <b>#{@municipio_ean.try(:nombre).strip}", :size => 9, :at => [-20,50], :height => 10, :width => 180, :align => :justify, :inline_format => true if @municipio_ean
pdf.text_box "Cod Postal: <b>#{@empresa.try(:cod_postal_ean).strip}", :size => 9, :at => [-20,40], :height => 10, :width => 180, :align => :justify, :inline_format => true 
pdf.text_box "Teléfono: <b>#{@empresa.try(:telefono1_ean).strip}", :size => 9, :at => [-20,30], :height => 10, :width => 180, :align => :justify, :inline_format => true 

