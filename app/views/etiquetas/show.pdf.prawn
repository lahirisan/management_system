pdf.text "<font size='11'> #{@empresa.nombre_empresa.strip} </font>",  :inline_format => true,  :align => :center
pdf.text_box "Contacto: <b>#{@empresa.rep_ean.strip}", :size => 9, :at => [0,180], :height => 10, :width => 180, :align => :justify, :inline_format => true
pdf.text_box "Cargo: <b>#{@empresa.rep_ean_cargo.strip}", :size => 9, :at => [0,170], :height => 10, :width => 180, :align => :justify, :inline_format => true
pdf.text_box "Dirección: <b>#{@empresa.direccion_ean.strip}", :size => 9, :at => [0,160], :height => 500, :width => 180, :align => :justify, :inline_format => true
pdf.text_box "Estado: <b>#{@estado_ean.try(:nombre).strip}", :size => 9, :at => [0,105], :height => 10, :width => 180, :align => :justify, :inline_format => true if @estado_ean
pdf.text_box "Ciudad: <b>#{@ciudad_ean.try(:nombre).strip}", :size => 9, :at => [0,95], :height => 10, :width => 180, :align => :justify, :inline_format => true if @ciudad_ean
pdf.text_box "Municipio: <b>#{@municipio_ean.try(:nombre).strip}", :size => 9, :at => [0,85], :height => 10, :width => 180, :align => :justify, :inline_format => true if @municipio_ean
pdf.text_box "Cod Postal: <b>#{@empresa.try(:cod_postal_ean).strip}", :size => 9, :at => [0,75], :height => 10, :width => 180, :align => :justify, :inline_format => true 
pdf.text_box "Teléfono: <b>#{@empresa.try(:telefono1_ean).strip}", :size => 9, :at => [0,65], :height => 10, :width => 180, :align => :justify, :inline_format => true 

