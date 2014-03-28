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

        // Datatable que maneja el listado para retirar empresas
        $("#data_table_empresas_retirar").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',
            sAjaxSource: $('#data_table_empresas_retirar').data('source')
        }).columnFilter({ aoColumns: [null, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

       
        
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

        //  Manejador del evento Change del campo Clasificacion
        $( "#empresa_id_clasificacion").change(function() {
            $.get('/clasificaciones/'+$(this).val()+'.json', function( data ) {
                $('#empresa_categoria').val(data.categoria); // campo categoria formulario crear Empresa
                $('#empresa_division').val(data.division); // campo division formulario crear Empresa
                $('#empresa_grupo').val(data.grupo); // campo grupo formulario crear Empresa
                $('#empresa_clase').val(data.clase); // campo clase formulario crear Empresa
                
            });

        });
        
        // Retiro masivo seleccionar / deseleccionar todos
        $('#retiro_masivo').live('change', function() {  
            if ($(this).is(':checked'))
            {
                $('.retirar_empresa').prop('checked', true);
            }
            else 
            {
                $('.retirar_empresa').prop('checked', false);
            }
        })
        
        // Verificacion que valida el estado del checkbox seleccionar todos cuando se hace la paginación (AJAX)
        
        jQuery.ajaxSetup({
            
            complete: function(){
                if (($('.retirar_empresa').size()) == ($(".retirar_empresa:checked").length))
                {
                    $('#retiro_masivo').prop('checked', true);
                }
                else
                {
                    $('#retiro_masivo').prop('checked', false);
                }
                
            },
          success: function() {}
        });

        // cuando  se hace submit del formulario se capturan los valores que tienen los combos de las empresas seleccionadas
        $('#formulario_retirar_empresa').submit(function( event ) { 

            // Se valida que se haya seleccionado 
            $(".retirar_empresa:checked").length)
            {
                
            }

            
            if ($('#retiro_masivo').is(':checked')) // retiro masivo
            {
               
                $('.retirar_empresa:checked').each(function() {
                    // Por cada empresa seleccionda se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                    $('#datos_empresas_retirar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#sub_estatus").val()+'_'+$("#motivo_retiro").val()+ '">');
                });   
            }
            else
            {
                $('.retirar_empresa:checked').each(function() {
                    // Por cada empresa seleccionda se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                    $('#datos_empresas_retirar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
                });
            }

        });

    })   

