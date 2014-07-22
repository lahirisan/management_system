pdf.text "<font size='15'> #{@etiqueta.empresa.nombre_empresa} </font>",  :inline_format => true
pdf.text "<font size='10'> Contacto: <b>#{@contacto.try(:nombre_contacto)}</b> </font>", :inline_format => true
pdf.text "<font size='10'> Telf Contacto: <b>#{@contacto.try(:contacto)}</b> </font>", :inline_format => true
pdf.text "<font size='10'>Cargo: <b>#{@contacto.try(:cargo_contacto)}</b></font>", :inline_format => true
pdf.text "<font size='10'>Edificio: <b>#{@etiqueta.try(:edificio)}</b></font>", :inline_format => true
pdf.text "<font size='10'>Calle: <b>#{@etiqueta.try(:calle)}</b></font>", :inline_format => true
pdf.text "<font size='10'>Urbanización: <b>#{@etiqueta.try(:urbanizacion)}</b></font>", :inline_format => true
pdf.text "<font size='10'>Cod Postal: <b>#{@etiqueta.try(:cod_postal)}</b></font>", :inline_format => true
pdf.text "<font size='10'>Punto Ref: <b>#{@etiqueta.try(:punto_referencia)}</b></font>", :inline_format => true
pdf.text "<font size='10'>Ciudad: <b>#{@etiqueta.try(:ciudad).try(:nombre)}</b></font>", :inline_format => true
pdf.text "<font size='10'>Estado: <b>#{@etiqueta.try(:estado).try(:nombre)}</b></font>", :inline_format => true

