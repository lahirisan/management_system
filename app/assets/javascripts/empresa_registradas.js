$( document ).ready(function() {
	
	// Datatable que maneja el listado de empresas

    $("#data_table_empresa_registradas").dataTable({
        sPaginationType: "full_numbers",
        bJQueryUI: true,
        aaSorting: [[ 2, "desc" ]],
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',
        sAjaxSource: $('#data_table_empresa_registradas').data('source')
    }).columnFilter({ aoColumns: [{ type: "text"}, { type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"} , {type: "text"}]});;


	$('#empresa_registrada_ventas_brutas_anuales').change(function() {

		if (($(this).val() == '0 a 200.000') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
			$('#empresa_registrada_aporte_mantenimiento_bs').val('3400.00');
		if (($(this).val() == 'De 200.001,00 a 2.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('5700.00');
		if (($(this).val() == 'De 2.000.001,00 a 4.500.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('12500.00');
		if (($(this).val() == 'De 4.500.001,00 a 6.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('21700.00');
		if (($(this).val() == 'De 6.000.0001,00 o más') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('27000.00');

		if (($(this).val() == '0 a 200.000') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
			$('#empresa_registrada_aporte_mantenimiento_bs').val('3400.00');
		if (($(this).val() == 'De 200.001,00 a 2.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('3400.00');
		if (($(this).val() == 'De 2.000.001,00 a 4.500.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('4500.00');
		if (($(this).val() == 'De 4.500.001,00 a 6.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('7900.00');
		if (($(this).val() == 'De 6.000.0001,00 o más') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('21700.00');

	});

	$("#data_table_empresa_registradas_activar_solvencia").dataTable({
        sPaginationType: "full_numbers",
        aoColumns: [ { "bSortable": false }, null,null, null, null, null, null],
        bJQueryUI: true,
        aaSorting: [[ 2, "desc" ]],
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',
        sAjaxSource: $('#data_table_empresa_registradas_activar_solvencia').data('source')
    }).columnFilter({ aoColumns: [null, { type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}]});

    $('.nuevo_registro_activar_solvencia').hover(
      function() { $(this).addClass('ui-state-hover'); },
      function() { $(this).removeClass('ui-state-hover');}
    );

    $('#activar_solvencia').submit(function( event ) {
            

            if ($(".activar_solvencia:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ninguna nueva empresa para asignar como SOLVENTE. Por favor verifique.");
                return false;
            }

    });

     //  Manejador del evento Change del campo Clasificacion
        $( "#empresa_registrada_id_clasificacion").change(function() {
            $.get('/clasificaciones/'+$(this).val()+'.json', function( data ) {
                $('#empresa_registrada_categoria').val(data.categoria); // campo categoria formulario crear Empresa
                $('#empresa_registrada_division').val(data.division); // campo division formulario crear Empresa
                $('#empresa_registrada_grupo').val(data.grupo); // campo grupo formulario crear Empresa
                $('#empresa_registrada_clase').val(data.clase); // campo clase formulario crear Empresa
            });

        });

        $('#asignar_prefijo_manual').dialog({
          autoOpen: false,
          width: 900
         
        });

        // Botón para abrir el dialogo
        $('#boton_abrir_ventana_prefijo_manual').click(function(w){
          w.preventDefault(); // Deshabilita el hipervinculo el boton importar
          

          $('#prefijos_disponibles').dataTable({
            bDestroy: true,
            bJQueryUI: true,
            aaSorting: [[ 3, "asc" ]],

          });
          $('#asignar_prefijo_manual').dialog('open').attr('class', 'ventana_prefijo_manual');
          
        });

        //cierra la ventana para asignar prefijo manual
        $('#regresar_formulario_empresa').click(function(){
            $('.ventana_prefijo_manual').dialog('close');
            
        });

        // Accion del boton asignar prefijo en la ventana

        $('.boton_asignar_prefijo_manual').click(function(){

            if ($('#prefijo_manual').val() == '')
            {
                alert('Estimado usuario, no ha ingresado ningún PREFIJO para ser reutilizado');
            }
            else
            {
                $('#empresa_registrada_prefijo').val($('#prefijo_manual').val());

                $.get("/clasificaciones.json?categoria="+$('#'+$('#prefijo_manual').val()+'_categoria').text()+"&division="+$('#'+$('#prefijo_manual').val()+'_division').text()+"&grupo="+$('#'+$('#prefijo_manual').val()+'_grupo').text()+"&clase="+$('#'+$('#prefijo_manual').val()+'_clase').text(), function( data ) { 

                    $('#empresa_registrada_id_clasificacion').val(data.id).change(); // Se modifica la clasificacion de la empresa
                
                });
                
                $('.ventana_prefijo_manual').dialog('close');
            }

        });

         // Actualizar la ciudad dependiendo del estado seleccionado - Datos Basicos
        $( "#empresa_registrada_id_estado").change(function() {
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });
           

        });

        // Lod datos de correspondencia

        $( "#empresa_registrada_id_estado_ean").change(function() {
            
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad_ean");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });

            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
                var  municipios = $("#empresa_registrada_id_municipio_ean");
                municipios.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    municipios.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });       

        });


        $( "#empresa_registrada_id_estado_edi").change(function() {
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad_edi");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });

            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
                var  municipios = $("#empresa_registrada_id_municipio_edi");
                municipios.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    municipios.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });       

        });

        // Datepicker de la fecha

        if (window.location.pathname.split('/')[3] != 'edit')
        {
            // Datepicker los ultimos 100 anhos
            $("#empresa_registrada_fecha_registro_mercantil").datepicker({yearRange: "-100:+0",
                changeYear: true});
        }


	
});