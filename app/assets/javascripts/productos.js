  $( document ).ready(function() {

        // Datatable que maneja el listado de productos
        $("#data_table_productos").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 8, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"},{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_retirar_productos").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 9, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_retirar_productos').data('source')
        }).columnFilter({ aoColumns: [null, { type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_productos_retirados").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 11, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_retirados').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_productos_eliminados").dataTable({
            sPaginationType: "full_numbers",
              aaSorting: [[ 9, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_eliminados').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_eliminar_productos").dataTable({
            sPaginationType: "full_numbers",
             aaSorting: [[ 12, "desc" ]],
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
            var seleccion_invalida = false;

            if ($('#retiro_masivo_productos').is(':checked')) // retiro masivo
                // Se valida que se haya selccioando un sub_estatus y motivo_ret para el retiro masivo
            {
                if ($('#retirar_producto_sub_estatus').val() == 1)
                {
                    alert('Estimado usuario, no ha selecciona un SUB ESTATUS para asignar masivamente. Por favor verifique');
                    seleccion_invalida = true;
                    return false;

                }

                if ($('#retirar_producto_motivo_retiro').val() == 1)
                {
                    alert('Estimado usuario, no ha selecciona un MOTIVO RETIRO para asignar masivamente. Por favor verifique');
                    seleccion_invalida = true;
                    return false;

                }

                $('.retirar_producto:checked').each(function() {
                    // Por cada producto seleccionado se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
                    $('#datos_productos_retirar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#retirar_producto_sub_estatus").val()+'_'+$("#retirar_producto_motivo_retiro").val()+ '">');
                });   
            }
            else // múltiple selecccion de empresas a retirar
            {
                $('.retirar_producto:checked').each(function() {

                    // Se valida que el usuario haya seleccion un subestatus para retirar el GTIN
                    if ($('#'+$(this).val()+'sub_estatus').val() == 1)
                    {
                        alert('Estimado usuario, no ha seleccionado un SUB ESTATUS para el GTIN '+ $(this).val());
                        seleccion_invalida = true;
                        return false;
                    }

                    // Se valida que el usaurio haya selccionado un motivo de retiro pra el GTIN
                    if ($('#'+$(this).val()+'motivo_ret').val() == 1)
                    {
                        alert('Estimado usuario, no ha seleccionado un MOTIVO RETIRO para el GTIN '+ $(this).val());
                        seleccion_invalida = true;
                        return false;
                    }

                    // Por cada producto selecciondo se toma el valor de su id y el de sus campos sub_estatus y motivo retiro
                    $('#datos_productos_retirar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
                });
            }

            if (seleccion_invalida)
                return false;

            if (!(confirm('Esta seguro RETIRAR los productos seleccionados ?')))
                return false;
           
        });

        

        // Efectos del boton importar
        $('.boton_importar, .retirar_productos,   .eliminar_productos').hover(
          function() { $(this).addClass('ui-state-hover'); },
          function() { $(this).removeClass('ui-state-hover');}
        );

        // Dialogo importar productos oculto por defecto
        $('.importar_producto').dialog({
          autoOpen: false,
          width: 500
        });

        // Botón para abrir el dialogo
        $('.boton_importar').click(function(w){
            w.preventDefault(); // Deshabilita el hipervinculo el boton importar
            $('.importar_producto').dialog('open');
        });

        // validacion importar archivo
        $('#importar_archivo').submit(function( event ) { 
             
            if ($('#archivo_excel').val() == '')
            {
                alert('Estimado usuario, no ha seleccionado nigún archivo excel del cual se importará los datos. Por favor verifique.');
                return false;               
            }

            if ($('#tipo_gtin').val() == '')
            {
                alert('Estimado usuario, debe seleccionar el TIPO GTIN asociado a los productos que se van a importar. Por favor verifique');
                return false;                 
            }


        })


    })   

