  $( document ).ready(function() {

        // Datatable que maneja el listado de productos
        $("#data_table_productos").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_retirar_productos").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_retirar_productos').data('source')
        }).columnFilter({ aoColumns: [null, { type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_productos_retirados").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_retirados').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_productos_eliminados").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_eliminados').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_eliminar_productos").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_eliminar_productos').data('source')
        }).columnFilter({ aoColumns: [null, { type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}    ]});

        // formulario eliminar producto

        $('#formulario_eliminar_productos').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".eliminar_producto:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ningún producto para ELIMINAR. Por favor verifique.");
                return false;
            }

            if ($('#eliminar_masivo_productos').is(':checked')) // elimino masivo
            {  
                $('.eliminar_producto:checked').each(function() {
                    // Por cada producto seleccionado se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
                    $('#datos_productos_eliminar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#sub_estatus").val()+'_'+$("#motivo_retiro").val()+ '">');
                });   
            }
            else 
            {
                $('.eliminar_producto:checked').each(function() {
                    // Por cada producto selecciondo se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                    $('#datos_productos_eliminar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
                });
            }

           
        });

        // Retiro masivo seleccionar / deseleccionar todos
        $('#eliminar_masivo_productos').live('change', function() {
            
            if ($(this).is(':checked'))
            {
                $('.eliminar_producto').prop('checked', true);
            }
            else 
            {
                $('.eliminar_producto').prop('checked', false);
            }  
            
        });

        // ELiminar masivo seleccionar / deseleccionar todos
        $('#retiro_masivo_productos').live('change', function() {
            
            if ($(this).is(':checked'))
            {
                $('.retirar_producto').prop('checked', true);
            }
            else 
            {
                $('.retirar_producto').prop('checked', false);
            }  
            
        });

        $('#formulario_retirar_productos').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".retirar_producto:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ningún producto para RETIRAR. Por favor verifique.");
                return false;
            }

            if ($('#retiro_masivo_productos').is(':checked')) // retiro masivo
            {  
                $('.retirar_producto:checked').each(function() {
                    // Por cada producto seleccionado se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
                    $('#datos_productos_retirar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#sub_estatus").val()+'_'+$("#motivo_retiro").val()+ '">');
                });   
            }
            else // múltiple selecccion de empresas a retirar
            {
                $('.retirar_producto:checked').each(function() {
                    // Por cada producto selecciondo se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                    $('#datos_productos_retirar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
                });
            }
           
        });


    })   

