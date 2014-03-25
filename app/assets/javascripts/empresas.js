  $( document ).ready(function() {
        // Datatable que maneja el listado de empresas
        $("#data_table_empresas").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',
            sAjaxSource: $('#data_table_empresas').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, { type: "text"}, {type: "text"}, {type: "text"}, { type: "text"}]});

         // Datatable que maneja el listado de empresas activacion
        $("#data_table_empresas_activacion").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',
            sAjaxSource: $('#data_table_empresas_activacion').data('source')
        }).columnFilter({ aoColumns: [null, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, { type: "text"}, {type: "text"}, {type: "text"}, { type: "text"}, { type: "text"}]});

        // Se obtiene el Prefijo
        
        // Datepicker para la fecha de creacion de la empresa
        $("#empresa_fecha_inscripcion").datepicker();

        // Actualizar la ciudad dependiendo del estado seleccionado - Datos Basicos
        $( "#empresa_id_estado").change(function() {
        	
        	//AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
        	$.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
 				var ciudades = $("#empresa_id_ciudad");
 				ciudades.empty() // Se eliminan las opciones del select ciudades
 				
 				$.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
  					ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
				});

        	})
		});

        // Verificar el cambio del select  estado de la correspondencia
		$( "#empresa_correspondencia_attributes_id_estado").change(function() {
        	
        	//AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
        	$.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
 				var correspondencia_ciudades = $("#empresa_correspondencia_attributes_id_ciudad");
 				correspondencia_ciudades.empty() // Se eliminan las opciones del select ciudades
 				
 				$.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
  					correspondencia_ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
				});

        	})
		});

        //  Manejador del evento change clasificacion
        $( "#empresa_id_clasificacion").change(function() {
            $.get('/clasificaciones/'+$(this).val()+'.json', function( data ) {
                $('#empresa_categoria').val(data.categoria); // campo categoria formulario crear Empresa
                $('#empresa_division').val(data.division); // campo division formulario crear Empresa
                $('#empresa_grupo').val(data.grupo); // campo grupo formulario crear Empresa
                $('#empresa_clase').val(data.clase); // campo clase formulario crear Empresa
                
            });

        });
    })   

