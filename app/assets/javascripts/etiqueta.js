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

});


