$( document ).ready(function() {
	
    
    // Datatable que maneja el listado de servicios
    $("#data_table_empresa_servicios").dataTable({
        sPaginationType: "full_numbers",
        aaSorting: [[ 2, "desc" ]],
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_empresa_servicios').data('source')
    }).columnFilter({ aoColumns: [null, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

    $('#data_table_empresa_servicios input').attr("placeholder", "Buscar");

    // Datatable eliminar_servicios

    $("#data_table_eliminar_empresa_servicios").dataTable({
        sPaginationType: "full_numbers",
        aaSorting: [[ 1, "desc" ]],
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_eliminar_empresa_servicios').data('source')
    }).columnFilter({ aoColumns: [null, null, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"},{type: "text"}, null]});
    $('#data_table_eliminar_empresa_servicios input').attr("placeholder", "Buscar");


    $("#data_table_empresa_servicios_eliminados").dataTable({
        sPaginationType: "full_numbers",
        aaSorting: [[ 9, "desc" ]],
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_empresa_servicios_eliminados').data('source')
    }).columnFilter({ aoColumns: [null, { type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

    $('#data_table_empresa_servicios_eliminados input').attr("placeholder", "Buscar");


    if (window.location.pathname.split('/')[5] != 'edit')
    {
        $("#empresa_servicio_fecha_contratacion").datepicker();
        
        $("#empresa_servicio_fecha_finalizacion").datepicker();
    }

    // Eliminar servicio masivamente
    $('#eliminar_masivo_servicios').live('change', function() {
            
        if ($(this).is(':checked'))
        {
            $('.eliminar_servicio').prop('checked', true);
        }
        else 
        {
            $('.eliminar_servicio').prop('checked', false);
        }  
            
    });


    $('#formulario_eliminar_servicios').submit(function( event ) { 
            
        // Se valida que se haya seleccionado alguna servicio para eliminar
        if ($(".eliminar_servicio:checked").length == 0)
        {
            alert("Estimado usuario, no ha seleccionado ningún SERVICIO para ELIMINAR. Por favor verifique.");
            return false;
        }
        
        var seleccion_invalida = false;
         
        if ($('#eliminar_masivo_servicios').is(':checked')) // elimino masivo
        {  
            if ($('#eliminar_servicio_sub_estatus').val() == 1)
            {
                alert('Estimado usuario, para ELIMINAR no ha selecciona un SUB ESTATUS para asignar masivamente. Por favor verifique');
                seleccion_invalida = true;
                return false;

            }

            if ($('#eliminar_servicio_motivo_retiro').val() == 1)
            {
                alert('Estimado usuario, para ELIMINAR no ha selecciona un MOTIVO RETIRO para asignar masivamente. Por favor verifique');
                seleccion_invalida = true;
                return false;

            }   
            
            $('.eliminar_servicio:checked').each(function() {
                
                // Por cada servicio seleccionado se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
                $('#datos_servicio_eliminar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$('#eliminar_servicio_sub_estatus').val()+'_'+$('#eliminar_servicio_motivo_retiro').val()+ '">');
            });   
        }
        else 
        {
            $('.eliminar_servicio:checked').each(function() {



                // Se valida que el usuario haya seleccion un subestatus para retirar el GTIN
                if ($('#'+$(this).val()+'sub_estatus').val() == 1)
                {
                    alert('Estimado usuario, no ha seleccionado un SUB ESTATUS para el SERVICIO ' + $('.clase'+$(this).val()).text());
                    seleccion_invalida = true;
                    return false;
                }

                // Se valida que el usaurio haya selccionado un motivo de retiro pra el GTIN
                if ($('#'+$(this).val()+'motivo_ret').val() == 1)
                {
                    alert('Estimado usuario, no ha seleccionado un MOTIVO RETIRO para el SERVICIO '+ $('.clase'+$(this).val()).text());
                    seleccion_invalida = true;
                    return false;
                }

                // Por cada servicio selecciondo se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                $('#datos_servicio_eliminar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$('#'+$(this).val()+'sub_estatus').val()+'_'+$('#'+$(this).val()+'motivo_ret').val()+ '">');
            });
        }



        if (seleccion_invalida)
                return false;

        if (!(confirm('Esta seguro ELIMINAR los servicios seleccionados ?')))
            return false;
           
    });

    $('#new_empresa_servicio').submit(function( event ) { 
        
        var fecha_inicio = new Date($('#empresa_servicio_fecha_contratacion').val());
        var fecha_finalizacion = new Date($('#empresa_servicio_fecha_finalizacion').val());
        
        if (fecha_inicio >= fecha_finalizacion)
        {
            alert('La fecha de culminación del servicio debe ser mayor que la fecha de contratación ');
            return false;
        }

    });

    // Efectos del boton importar
        $('.guardar_servicio, .exportar_servicios_eliminados, .exportar_servicios, .exportar_servicios_eliminar').hover(
          function() { $(this).addClass('ui-state-hover'); },
          function() { $(this).removeClass('ui-state-hover');}
        );

    $(".exportar_servicios").click(function() {
        $('.parametros').html(
            '<input name="servicio" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
            '<input name="fecha_contratacion" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
            '<input name="fecha_finalizacion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
            '<input name="nombre_contacto" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
            '<input name="cargo_contacto" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
            '<input name="telefono" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
            '<input name="correo" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'
        );
    });

    $(".exportar_servicios_eliminar").click(function() {
        $('.parametros').html(
            '<input name="servicio" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
            '<input name="fecha_contratacion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
            '<input name="fecha_finalizacion" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
            '<input name="nombre_contacto" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
            '<input name="cargo_contacto" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
            '<input name="telefono" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
            '<input name="correo" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'+
            '<input name="eliminar" type="hidden" value="true">'
        );
    });

    $(".exportar_servicios_eliminados").click(function() {
        $('.parametros').html(
            '<input name="servicio" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
            '<input name="fecha_contratacion" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
            '<input name="fecha_finalizacion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
            '<input name="nombre_contacto" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
            '<input name="cargo_contacto" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
            '<input name="telefono" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
            '<input name="correo" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
            '<input name="subestatus" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'+
            '<input name="motivo_retiro" type="hidden" value="'+$('tfoot tr th:nth-child(10) span input').val()+'">'+
            '<input name="fecha_eliminacion" type="hidden" value="'+$('tfoot tr th:nth-child(11) span input').val()+'">'+
            '<input name="eliminados" type="hidden" value="true">'
        );
    });


     
});
