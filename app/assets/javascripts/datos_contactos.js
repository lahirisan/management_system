$( document ).ready(function() {
    // Datatable que maneja el listado datos de contacto

	$("#data_table_empresas_datos_contacto").dataTable();
    
    $('.nuevo_contacto').hover(
     
          function() { $(this).addClass('ui-state-hover'); },
          function() { $(this).removeClass('ui-state-hover');
    });
	
	// validacion el formato del correo

	$('#formulario_datos_contacto').submit(function( event ) {

		if ($( "#datos_contacto_tipo option:selected" ).text() == 'email')
        {  
            expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if ( !expr.test($('#datos_contacto_contacto').val()) )
            {
                alert("Datos de Contacto: EL formato de la dirección de correo " + $('#datos_contacto_contacto').val() + " es incorrecta.");
                return false;
            }
    	}
    
	});

});


