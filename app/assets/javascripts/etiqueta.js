$( document ).ready(function() {
   // Verificar el cambio del select  estado de la correspondencia
    $( "#id_estado").change(function() {
        
        //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
        $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
            var ciudades = $("#id_ciudad");
            ciudades.empty() // Se eliminan las opciones del select ciudades
            
            $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
            });
        })

        //AJAX que obtiene las municpios dependiendo Que cumplen la condicion del estado seleccioando
        $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
            var municipios = $("#id_municipio");
            municipios.empty() // Se eliminan las opciones del select ciudades
            
            $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                municipios.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
            });
        })
    });
    
    $('#tipo_correspondencia_etiqueta').change(function() {

        var tipo_correspondencia = $(this).val();
        
        $.get("/empresas/"+window.location.pathname.split('/')[2]+".json" , function( data ) {

            if (tipo_correspondencia == 'edi')
            {
                
                $('td.etiqueta_nombre_contacto').text(data.rep_edi);
                $('td.etiqueta_cargo').text(data.rep_edi_cargo);
                $('td.etiqueta_punto_ref').text(data.punto_ref_edi);
                $('td.etiqueta_cod_postal').text(data.codigo_postal_edi);
                $('td.etiqueta_telefono').text(data.telefono1_edi);
                $('td.etiqueta_direccion').text(data.direccion_edi);
                $('td.etiqueta_parroquia').text(data.parroquia_edi);


                $.get("/municipios/"+data.id_municipio_edi+".json", function(municipio){

                    $('td.etiqueta_municipio').text(municipio.nombre);

                });

                $.get("/ciudades/"+data.id_ciudad_edi+".json", function(ciudad){

                    $('td.etiqueta_ciudad').text(ciudad.nombre);

                });


                if (data.id_estado_edi)

                {
                    $.get("/estados/"+data.id_estado_edi+".json", function(estado){

                        $('td.etiqueta_estado').text(estado.nombre);

                    });


                }


            }

            if (tipo_correspondencia == 'ean')
            {
                
                $('td.etiqueta_nombre_contacto').text(data.rep_ean);
                $('td.etiqueta_cargo').text(data.rep_ean_cargo);
                $('td.etiqueta_punto_ref').text(data.punto_ref_ean);
                $('td.etiqueta_cod_postal').text(data.codigo_postal_ean);
                $('td.etiqueta_telefono').text(data.telefono1_ean);
                $('td.etiqueta_direccion').text(data.direccion_ean);
                $('td.etiqueta_parroquia').text(data.parroquia_ean);


                $.get("/municipios/"+data.id_municipio_ean+".json", function(municipio){

                    $('td.etiqueta_municipio').text(municipio.nombre);

                });

                $.get("/ciudades/"+data.id_ciudad_ean+".json", function(ciudad){

                    $('td.etiqueta_ciudad').text(ciudad.nombre);

                });

                if (data.id_estado_ean)

                {
                    $.get("/estados/"+data.id_estado_ean+".json", function(estado){

                        $('td.etiqueta_estado').text(estado.nombre);
                    });

                }


            }
            
        
        });

    });

});


