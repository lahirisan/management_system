$( document ).ready(function() {
	// Datatable que maneja el listado de servicios
    $("#data_table_empresa_servicios").dataTable({
        sPaginationType: "full_numbers",
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_empresa_servicios').data('source')
    }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});;

    // Datatable eliminar_servicios

    // $("#data_table_eliminar_servicios").dataTable({
    //     sPaginationType: "full_numbers",
    //     bJQueryUI: true,
    //     bProcessing: true,
    //     bServerSide: true,
    //     sDom: 'T<"clear">lfrtip',            
    //     sAjaxSource: $('#data_table_eliminar_servicios').data('source')
    // });

    

    if (window.location.pathname.split('/')[4] == 'new')
    {
        $("#empresa_servicio_fecha_contratacion").datepicker();
        
        $("#empresa_servicio_fecha_finalizacion").datepicker();
    }

    // // Eliminar servicio masivamente
    // $('#eliminar_masivo_servicios').live('change', function() {
            
    //     if ($(this).is(':checked'))
    //     {
    //         $('.eliminar_servicio').prop('checked', true);
    //     }
    //     else 
    //     {
    //         $('.eliminar_servicio').prop('checked', false);
    //     }  
            
    // });


    // $('#formulario_eliminar_servicios').submit(function( event ) { 
            
    //     // Se valida que se haya seleccionado alguna servicio para eliminar
    //     if ($(".eliminar_servicio:checked").length == 0)
    //     {
    //         alert("Estimado usuario, no ha seleccionado ningún SERVICIO para ELIMINAR. Por favor verifique.");
    //         return false;
    //     }
    //     if ($('#eliminar_masivo_servicios').is(':checked')) // elimino masivo
    //     {  
            
    //         $('.eliminar_servicio:checked').each(function() {
                
    //             // Por cada servicio seleccionado se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
    //             $('#datos_servicio_eliminar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#sub_estatus").val()+'_'+$("#motivo_retiro").val()+ '">');
    //         });   
    //     }
    //     else 
    //     {
    //         $('.eliminar_servicio:checked').each(function() {
    //             // Por cada servicio selecciondo se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
    //             $('#datos_servicios_eliminar').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
    //         });
    //     }

        
           
    // });

});
