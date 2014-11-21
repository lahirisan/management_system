draw_text "Caracas #{Time.now.strftime("%d-%m-%Y")}", :size => 10, :at => [390,655]
draw_text "#{@empresa.nombre_empresa}", :size => 10, :at => [0,620], :styles => [:bold]
draw_text "Presente.-", :size => 10, :at => [0,605]
draw_text "Atn: #{@empresa.rep_legal}", :size => 10, :at => [320,590]
draw_text "#{@empresa.cargo_rep_legal}", :size => 10, :at => [320,575]
draw_text "Estimado Sr(a).", :size => 10, :at => [0,545]


text_box "La Asociación para la Codificación Internacional de Productos de Venezuela, GS1 Venezuela, Asociación encargada de administrar  en nuestro  país el Sistema de  Identificación y  Comunicación GS1, le da la más cordial bienvenida y hace de su conocimiento que se ha completado satisfactoriamente su afiliación otorgándole a la empresa #{@empresa.nombre_empresa.strip}, el Prefijo de Compañía Nº #{@empresa.prefijo}.", :size => 9, :at => [0,515], :height => 40, :width => 500, :align => :justify

text_box "A partir de la presente fecha todos sus productos podrán incluir en el espacio correspondiente a la identificación de la Empresa, el Código GS1 para ustedes establecido. Además, GS1 Venezuela, le ha otorgado a #{@empresa.nombre_empresa.strip}, el Código de localización Legal Nº#{@gln_legal.try(:gln)} . Este Código servirá como identificación de su empresa en comunidades de comercio electrónico.", :size => 9, :at => [0,470], :height => 40, :width => 500, :align => :justify


text_box "Anexo encontrará el recibo original por concepto de afiliación.", :size => 9, :at => [0,420], :height => 10, :width => 500, :align => :justify

text_box "Lo invitamos a que nos contacte para darle la asistencia que ustedes requieran en materia de ubicación y lectura del código de barras en los empaques, de esta manera lograremos que sus productos lleguen al mercado nacional o internacional perfectamente codificados. Además tenemos empresas miembros, que prestan a los afiliados el servicio de elaboración de películas maestras y/o etiquetas.", :size => 9, :at => [0,400], :height => 40, :width => 500, :align => :justify


text_box "La Gerencia de Administración, en atención al Art. 3 del Régimen de Contribuciones y el Art. 12 de los Estatutos de GS1, le enviara en el 1er. Trimestre de cada año una factura correspondiente al aporte de mantenimiento para #{@empresa.nombre_empresa.strip} el cual se ajustara anualmente de acuerdo al INDICE DE PRECIOS AL CONSUMIDOR (I.P.C), calculado conforme a la metodología usada por el BANCO CENTRAL DE VENEZUELA (B.C.V), según lo establecido en la clausula Séptima del contrato de afiliación GS1 Venezuela.", :size => 9, :at => [0,350], :height => 50, :width => 500, :align => :justify

text_box "Es importante señalar que cualquier cambio que se realice en su empresa, bien sea de nombre o razón social , dirección, teléfonos, persona contacto, representante legal y cualquier solicitud para la asignación de nuevos códigos para sus productos, deben enviarse vía fax a la atención de la Gerencia Técnica de GS1 Venezuela.", :size => 9, :at => [0,290], :height => 40, :width => 500, :align => :justify

text_box "Sin otro particular y quedando a su entera disposición para apoyarle en el manejo y aplicación de los estándares GS1.", :size => 9, :at => [0,250], :height => 40, :width => 500, :align => :justify

text_box "Luis Mejias Nuñez", :size => 10, :at => [10,190], :height => 10, :width => 500
text_box "Presidente Ejecutivo", :size => 10, :at => [10,178], :height => 10, :width => 500
text_box "GS1 Venezuela", :size => 10, :at => [10,166], :height => 10, :width => 500



 
 
