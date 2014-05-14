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

    // Datatable eliminar_servicios

    $("#data_table_eliminar_empresa_servicios").dataTable({
        sPaginationType: "full_numbers",
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_eliminar_empresa_servicios').data('source')
    }).columnFilter({ aoColumns: [null, null, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"},{type: "text"}, null]});


    $("#data_table_empresa_servicios_eliminados").dataTable({
        sPaginationType: "full_numbers",
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_empresa_servicios_eliminados').data('source')
    }).columnFilter({ aoColumns: [null, { type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});


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
                $('#datos_servicio_eliminar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$('#'+$(this).val()+'sub_estatus').val()+'_'+$('#'+$(this).val()+'motivo_ret').val()+ '">');
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

});
