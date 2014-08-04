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
    
});