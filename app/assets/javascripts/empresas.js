  $( document ).ready(function() {
        
        // Datatable que maneja el listado de empresas
        $("#data_table_empresas").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 2, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',
            sAjaxSource: $('#data_table_empresas').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

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
            aaSorting: [[ 0, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',
            sAjaxSource: $('#data_table_empresas_retirar').data('source')
        }).columnFilter({ aoColumns: [null, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});
        
        if (window.location.pathname.split('/')[2] == 'new')
        {
            $("#empresa_fecha_inscripcion").datepicker();
        }

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
        
        // Retiro masivo, activacion seleccionar / deseleccionar todos
        $('#retiro_masivo, #activacion_masiva').live('change', function() {  
            if ($(this).is(':checked'))
            {
                $('.retirar_empresa').prop('checked', true);
            }
            else 
            {
                $('.retirar_empresa').prop('checked', false);
            }

            // empresas retiradas
            if ($(this).is(':checked'))
            {
                $('.empresa_retirada').prop('checked', true);
            }
            else 
            {
                $('.empresa_retirada').prop('checked', false);
            }
        });

        // Eliminar masivo seleccionar / deseleccionar todos
        $('#eliminar_masivo').live('change', function() {
            if ($(this).is(':checked'))
            {
                $('.eliminar_empresa').prop('checked', true);
            }
            else 
            {
                $('.eliminar_empresa').prop('checked', false);
            }  
            
        });

        $('.loader').hide();

      
        jQuery.ajaxSetup({
            
            beforeSend: function() { // muestra el GIF que indica se está cargando el AJAX
               $('.loader').show();
            },
            complete: function(){

                // Verificacion que valida el estado del checkbox seleccionar todos cuando se hace la paginación (AJAX) retirar empresa
                if (($('.retirar_empresa').size()) == ($(".retirar_empresa:checked").length))
                {
                    $('#retiro_masivo').prop('checked', true);
                }
                else
                {
                    $('#retiro_masivo').prop('checked', false);
                }
                $('.loader').hide(); // oculta el GIF que indica se está cargando el AJAX
            },
          success: function() {
            
          }
        });
        // cuando  se hace submit del formulario se capturan los valores que tienen los combos de las empresas seleccionadas
        $('#formulario_retirar_empresa').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".retirar_empresa:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ninguna empresa para RETIRAR. Por favor verifique.");
                return false;
            }
            
            var seleccion_invalida;
            if ($('#retiro_masivo').is(':checked')) // retiro masivo
            {  
                $('.retirar_empresa:checked').each(function() {
                    
                    if ($("#"+$(this).val()+"sub_estatus").val() == 1)
                    {
                        alert('Debe seleccionar un Sub Estatus para la empresa con prefijo' + $(this).val());
                        seleccion_invalida = true;
                        return false;
                    }

                    if ($("#"+$(this).val()+"motivo_ret").val() == 1)
                    {
                        alert('Debe seleccionar un Motivo Retiro para la empresa con prefijo' + $(this).val());
                        seleccion_invalida = true;
                        return false;
                    }

                    // Por cada empresa seleccionda se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
                    $('#datos_empresas_retirar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#sub_estatus").val()+'_'+$("#motivo_retiro").val()+ '">');
                });   
            }
            else // múltiple selecccion de empresas a retirar
            {
                $('.retirar_empresa:checked').each(function() {
                   
                    if ($("#"+$(this).val()+"sub_estatus").val() == 1)
                    {
                        alert('Debe seleccionar un Sub Estatus para la empresa con prefijo ' + $(this).val());
                        seleccion_invalida = true;
                        return false;
                    }

                    if ($("#"+$(this).val()+"motivo_ret").val() == 1)
                    {
                        alert('Debe seleccionar un Motivo Retiro para la empresa con prefijo ' + $(this).val());
                        seleccion_invalida = true;
                        return false;
                    }

                    // Por cada empresa seleccionda se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                    $('#datos_empresas_retirar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
                });
            }

            if (seleccion_invalida)
                return false;

           
            if (!confirm('¿ Estimado usuario, está seguro de RETIRAR la(s) empresa(s) seleccionada(s) ?'))
                return false;
        });

        // Formulario eliminar empresa

        $('#formulario_eliminar_empresa').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".eliminar_empresa:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ninguna empresa para ELIMINAR. Por favor verifique.");
                return false;
            }
            if ($('#eliminar_masivo').is(':checked')) // Eliminacion masiva
            {  
                $('.eliminar_empresa:checked').each(function() {
                    // Por cada empresa seleccionda se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
                    $('#datos_empresas_eliminar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#sub_estatus").val()+'_'+$("#motivo_retiro").val()+ '">');
                });   
            }
            else // múltiple selecccion de empresas a eliminar
            {
                $('.eliminar_empresa:checked').each(function() {
                    // Por cada empresa seleccionda se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                    $('#datos_empresas_eliminar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
                });
            }

            if (!confirm('¿ Estimado usuario, está seguro de ELIMINAR la(s) empresa(s) seleccionada(s) ?'))
                return false;
        });

        $('#formulario_retiradas').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".empresa_retirada:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ninguna empresa para REACTIVAR. Por favor verifique.");
                return false;
            }
           
        });

        // Validacion  formato del email en apartado datos de contacto
        $('#formulario_crear_empresa').submit(function( event ) {

            if ($( "#empresa_datos_contacto_attributes_0_tipo option:selected" ).text() == 'email')
            {
               
               
                expr = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if ( !expr.test($('#empresa_datos_contacto_attributes_0_contacto').val()) )
                {
                    alert("Datos de Contacto: EL formato de la dirección de correo " + $('#empresa_datos_contacto_attributes_0_contacto').val() + " es incorrecta.");
                    return false;
                }
            }

        });

        // estilos de los botones exportar
        $('.exportar_excel, .exportar_csv, .exportar_pdf, .regresar, .retirar, .reactivar, .eliminar').hover(
     
          function() { $(this).addClass('ui-state-hover'); },
          function() { $(this).removeClass('ui-state-hover');
        });

        // Se le da espacio a la parte superiori del datatable entre los botones y el datatatable
        $('.dataTables_wrapper').css('margin-top', '30px');

        $('.exportar_excel').live('click', function(e) {
           
           $('#parametros_excel').html(
            '<input name="nombre_empresa" type="text" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">');
        });

    })   

