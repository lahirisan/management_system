$(document).ready( function () {
    $('#usuarios').DataTable({
    	 bJQueryUI: true,
    	 aaSorting: [[ 6, "desc" ]]
    });

    // Efectos del boton usaurios
    $('.editar_usuario').hover(
      function() { $(this).addClass('ui-state-hover'); },
      function() { $(this).removeClass('ui-state-hover');}
    );


    $('#usuario_id_gerencia').change(function() {

    	$.get("/perfiles.json?id_gerencia="+$(this).val(), function( data ) {

    		var perfiles = $("#usuario_id_perfil");
 				perfiles.empty() // Se eliminan las opciones del select perfiles
 				
 				$.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
  					perfiles.append('<option value="'+ value.id +'">'+value.descripcion+'</option>') // Se agregan las ciudades al select
				}); 
 

    	});

    })
    
});