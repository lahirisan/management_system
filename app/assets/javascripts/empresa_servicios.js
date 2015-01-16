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
        $('.guardar_servicio, .exportar_servicios, .exportar_servicios_eliminar').hover(
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

     
});
