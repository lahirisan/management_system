$(document).ready(function(){

        // Datatable que maneja el listado de productos
        $("#data_table_productos").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 8, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos').data('source')
        }).columnFilter({ aoColumns: [null, { type: "text"},{ type: "text"}, {type: "text" }, {type: "text"},  null, {type: "text"},null]});

        $('#data_table_productos input').attr("placeholder", "Buscar");

        // Datatable que maneja retirar productos
        $("#data_table_retirar_productos").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 9, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_retirar_productos').data('source')
        }).columnFilter({ aoColumns: [null, null, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, null, {type: "text"}, {type: "text"}, null, null]});

        $('#data_table_retirar_productos input').attr("placeholder", "Buscar");

        // Datatable que maneja retirar productos
        $("#data_table_productos_retirados").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 11, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_retirados').data('source')
        }).columnFilter({ aoColumns: [null, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, null, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        $('#data_table_productos_retirados input').attr("placeholder", "Buscar");

        // Datatable que maneja retirar productos
        $("#data_table_productos_eliminados").dataTable({
            sPaginationType: "full_numbers",
              aaSorting: [[ 9, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_eliminados').data('source')
        }).columnFilter({ aoColumns: [null, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"},  null, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        $('#data_table_productos_eliminados input').attr("placeholder", "Buscar");

        // Datatable que maneja retirar productos
        $("#data_table_eliminar_productos").dataTable({
            sPaginationType: "full_numbers",
             aaSorting: [[ 12, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_eliminar_productos').data('source')
        }).columnFilter({ aoColumns: [null, null, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, null, {type: "text"},  {type: "text"}, {type: "text"}, {type: "text"}  ]});

        $('#data_table_eliminar_productos input').attr("placeholder", "Buscar");

        // formulario eliminar producto

        $('#formulario_eliminar_productos').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".eliminar_producto:checked").length == 0)
            {
                
                alert("Estimado usuario, no ha seleccionado ningún producto para ELIMINAR. Por favor verifique.");
                return false;
            }
            var seleccion_invalida = false;

            if ($('#eliminar_masivo_productos').is(':checked')) // elimino masivo
            {  
                
                if ($('#sub_estatus').val() == 1)
                {
                    alert('Estimado usuario, no ha selecciona un SUB ESTATUS para asignar masivamente. Por favor verifique');
                    seleccion_invalida = true;
                    return false;

                }

                if ($('#motivo_retiro').val() == 1)
                {
                    alert('Estimado usuario, no ha selecciona un MOTIVO RETIRO para asignar masivamente. Por favor verifique');
                    seleccion_invalida = true;
                    return false;

                }

                $('.eliminar_producto:checked').each(function() {
                    // Por cada producto seleccionado se toma el valor de su id y el de los campos estatus y motivo retiro del control de retiro masivo
                    $('#datos_productos_eliminar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#sub_estatus").val()+'_'+$("#motivo_retiro").val()+ '">');
                });   
            }
            else 
            {
                $('.eliminar_producto:checked').each(function() {

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
                    $('#datos_productos_eliminar_productos').append('<input type="hidden" name="'+$(this).val()+'" value="'+$(this).val()+'_'+$("#"+$(this).val()+"sub_estatus").val()+'_'+$("#"+$(this).val()+"motivo_ret").val()+ '">');
                });
            }

           
            if (seleccion_invalida)
                return false;

            if (!(confirm('Esta seguro ELIMINAR los Productos seleccionados ?')))
                return false;

           
        });

        // Elimnar masivo seleccionar / deseleccionar todos
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
        $('.regresar_editar_empresa, .guardar_producto, .exportar_productos_eliminados, .exportar_productos_eliminar, .exportar_productos_retirados, .exportar_productos_retirar, .boton_importar, .retirar_productos,   .eliminar_productos, .exportar_productos').hover(
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
        });

        
        $("#producto_id_tipo_gtin" ).live('change', function() {

            if ($(this).val() == 3) // GTIN 13
            { 
                $('td.texto_manual_automatico').html("Tipo de Creación");  
                $('td.radio_manual_automatico').html('Automática<input id="tipo_creacion_automatica" name="tipo_creacion" type="radio" value="automatica">Manual<input id="tipo_creacion_manual" name="tipo_creacion" type="radio" value="manual">');  

                $("input[name='tipo_creacion']" ).live('change', function() {

                    if ($(this).val() == 'manual')
                    {
                        $('td.codigo_producto').html('Código producto');
                        $('td.valor_codigo_producto').html('<input id="producto_codigo_prod" name="producto[codigo_prod]" type="text" placeholder="12345">');

                    }
                    else
                    {
                     $('td.codigo_producto').html('');
                     $('td.valor_codigo_producto').html('');                       
                    }

                });
            }
            else
            {
                $('td.texto_manual_automatico').html("");  
                $('td.radio_manual_automatico').html('');
                $('td.codigo_producto').html('');
                $('td.valor_codigo_producto').html('');           
            }

        });

       
        $('#new_producto').submit(function( event ) {
          
           if ($('#producto_id_tipo_gtin').val() == '')
           {
               alert('Estimado usuario, debe seleccionar el Tipo de GTIN para poder continuar.')
               return false;
           }

           if (($('#producto_descripcion').val() == '') || ($('#producto_marca').val() == '') || ($('#producto_gpc').val() == ''))
           {
               alert('Estimado usuario, todos los campos son obligatorios para poder continuar.')
               return false;
           }
            
            if (($("input[type='radio'][name='tipo_creacion']:checked").val() == 'manual') && ($('#producto_id_tipo_gtin').val() == 3))
            {   
                var reg = /^[0-9]{5}$/;
                var cod_producto = $('#producto_codigo_prod').val();
                if ( !reg.test(cod_producto) )
                {
                    alert('Estimado usuario, el codigo producto debe ser un número de 5 dígitos. Por favor verifique');
                    return false;
                }
            }
                    
        });
        
        // Se verifica el codigo de producto
        $('#new_producto').submit(function( event ) {
            return verificar_codigo_producto();
        });

        $(".exportar_productos").click(function() {
            
            $('.parametros').html(
                '<input name="tipo_gtin" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
                '<input name="gtin" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="marca" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
                '<input name="codigo_producto" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'
            );
        });

        $(".exportar_productos_retirar").click(function() {

            $('.parametros').html(
                '<input name="tipo_gtin" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="gtin" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
                '<input name="marca" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
                '<input name="codigo_producto" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
                '<input name="retirar" type="hidden" value="true">'
            );

          
        });

        $(".exportar_productos_retirados").click(function() {

            $('.parametros').html(
                '<input name="tipo_gtin" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
                '<input name="gtin" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="marca" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
                '<input name="codigo_producto" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
                '<input name="fecha_creacion" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
                '<input name="subestatus" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'+
                '<input name="motivo_retiro" type="hidden" value="'+$('tfoot tr th:nth-child(10) span input').val()+'">'+
                '<input name="fecha_retiro" type="hidden" value="'+$('tfoot tr th:nth-child(11) span input').val()+'">'+
                '<input name="retirados" type="hidden" value="true">'
            );

          
        });

        $(".exportar_productos_eliminar").click(function() {

            $('.parametros').html(
                '<input name="tipo_gtin" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="gtin" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
                '<input name="marca" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
                '<input name="codigo_producto" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
                '<input name="fecha_creacion" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'+
                '<input name="subestatus" type="hidden" value="'+$('tfoot tr th:nth-child(10) span input').val()+'">'+
                '<input name="motivo_retiro" type="hidden" value="'+$('tfoot tr th:nth-child(11) span input').val()+'">'+
                '<input name="eliminar" type="hidden" value="true">'
            );

          
        });


        $(".exportar_productos_eliminados").click(function() {

            $('.parametros').html(
                '<input name="tipo_gtin" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
                '<input name="gtin" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="marca" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
                '<input name="codigo_producto" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
                '<input name="fecha_creacion" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
                '<input name="fecha_eliminacion" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'+
                '<input name="subestatus" type="hidden" value="'+$('tfoot tr th:nth-child(10) span input').val()+'">'+
                '<input name="motivo_retiro" type="hidden" value="'+$('tfoot tr th:nth-child(11) span input').val()+'">'+
                '<input name="eliminados" type="hidden" value="true">'
            );

          
        });

    

});



