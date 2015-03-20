$(document).ready(function(){

        // Datatable que maneja el listado de productos
        oTable = $("#data_table_productos").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 6, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos').data('source')
        });
       
        oTable.columnFilter({ aoColumns: [{ type: "text"},{ type: "text"}, {type: "text" }, {type: "text"},  null, {type: "text"}, {type: "text"}, {type: "text"}, null]});

       



//         jQuery.fn.dataTableExt.oApi.fnSetFilteringDelay = function ( oSettings, iDelay ) {
//             var _that = this;
         
//             if ( iDelay === undefined ) {
//                 iDelay = 250;
//             }
         
//             this.each( function ( i ) {
//                 $.fn.dataTableExt.iApiIndex = i;
//                 var
//                     $this = this,
//                     oTimerId = null,
//                     sPreviousSearch = null,
//                     anControl = $( 'input', _that.fnSettings().aanFeatures.f );
         
//                     anControl.unbind( 'keyup search input' ).bind( 'keyup search input', function() {
//                     var $$this = $this;
         
//                     if (sPreviousSearch === null || sPreviousSearch != anControl.val()) {
//                         window.clearTimeout(oTimerId);
//                         sPreviousSearch = anControl.val();
//                         oTimerId = window.setTimeout(function() {
//                             $.fn.dataTableExt.iApiIndex = i;
//                             _that.fnFilter( anControl.val() );
//                         }, iDelay);
//                     }
//                 });
         
//                 return this;
//             } );
//             return this;
//         };


// oTable.fnSetFilteringDelay()

        $('#data_table_productos input').attr("placeholder", "Buscar");

        // Datatable que maneja Eliminar productos
        $("#data_table_eliminar_productos").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 7, "desc" ]],
            aoColumns: [{ "bSortable": false }, null,  null, null,  null, { "bSortable": false }, null,null],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_eliminar_productos').data('source')
        }).columnFilter({ aoColumns: [null, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, null, {type: "text"},  {type: "text"} ]});

        $('#data_table_eliminar_productos input').attr("placeholder", "Buscar");

        // Datatable que maneja Eliminar productos
        $("#data_table_productos_general").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 0, "asc" ]],
            aoColumns: [{ "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true},{ "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true}],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_general').data('source')
        }).columnFilter({ aoColumns: [{type: "text" }, {type: "text" },  null,  {type: "text"}, {type: "text"}, {type: "text"},  {type: "text"} , {type: "text"}, {type: "text"}]});
        $('#data_table_productos_general input').attr("placeholder", "Buscar");


        // Datatable que maneja Eliminar productos
        $("#data_table_transferir_productos").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 1, "asc" ]],
            aoColumns: [ { "bSortable": false}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true},{ "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true}, { "bSortable": true}],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_transferir_productos').data('source')
        }).columnFilter({ aoColumns: [null, {type: "text" }, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"},  {type: "text"} , {type: "text"}, {type: "text"}]});
        
        $('#data_table_transferir_productos input').attr("placeholder", "Buscar");


        // formulario eliminar producto

        $('#formulario_eliminar_productos').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".eliminar_producto:checked").length == 0)
            {
                
                alert("Estimado usuario, no ha seleccionado ningún producto para ELIMINAR. Por favor verifique.");
                return false;
            }
            

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

        
        // Efectos del boton importar
        $('.regresar_editar_empresa, .guardar_producto,  .exportar_productos_eliminar,  .boton_importar, .eliminar_productos, .exportar_productos, .boton_transferir_productos').hover(
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

        });

       
        $('#new_producto').submit(function( event ) {
            
           
            if ($('#exceso_productos').val())
            {
                alert('Estimado usuario, esta empresa ya llego al límite de productos GTIN-13 que puede codificar. Por favor verifique.');
                return false;
            }

           if ($('#producto_id_tipo_gtin').val() == '')
           {
               alert('Estimado usuario, debe seleccionar el Tipo de GTIN para poder continuar.');
               return false;
           }

           if (($('#producto_descripcion').val() == '') || ($('#producto_marca').val() == '') || ($('#producto_gpc').val() == ''))
           {
               alert('Estimado usuario, todos los campos son obligatorios para poder continuar.');
               return false;
           }
            

            if (($("input[type='radio'][name='tipo_creacion']:checked").val() == 'manual') && ($('#producto_id_tipo_gtin').val() == 3) &&  ((window.location.pathname.split('/')[2].length == 7) || (window.location.pathname.split('/')[2].length == 5)))
            {   
                var reg = /^[0-9]{5}$/;
                var cod_producto = $('#producto_codigo_prod').val();
                if ( !reg.test(cod_producto) )
                {
                    alert('Estimado usuario, el código producto debe ser un valor de 5 dígitos numéricos. Por favor verifique.');
                    return false;
                }

                if (cod_producto == '00000')
                {
                    alert('Estimado usuario, el código de producto debe ser un valor de 5 dígitos numéricos distinto de 00000. Por favor verifique.');
                    return false;
                }
            }

            
            if (($("input[type='radio'][name='tipo_creacion']:checked").val() == 'manual') && ($('#producto_id_tipo_gtin').val() == 3) &&  (window.location.pathname.split('/')[2].length == 9) && (window.location.pathname.split('/')[2].substring(3, 6) == '400'))
            {   
                var reg = /^[0-9]{3}$/;
                var cod_producto = $('#producto_codigo_prod').val();
                if ( !reg.test(cod_producto) )
                {
                    alert('Estimado usuario, el código producto debe ser un valor de 3 dígitos numéricos. Por favor verifique.');
                    return false;
                }
                
                if (cod_producto == '000')
                {
                    alert('Estimado usuario, el código de producto debe ser un valor de 3 dígitos numéricos distinto de 00000. Por favor verifique.');
                    return false;
                }

            }

            // validacion formato de codigo prodcuto para tipo gtin8 manual
            
            if (($("input[type='radio'][name='tipo_creacion']:checked").val() == 'manual') && ($('#producto_id_tipo_gtin').val() == 1)) 
            {   
                var reg = /^[0-9]{4}$/;
                var cod_producto = $('#producto_codigo_prod').val();
                if ( !reg.test(cod_producto) )
                {
                    alert('Estimado usuario, el código producto debe ser un valor de 4 dígitos numéricos para la creación de Tipo GTIN 8 Manual. Por favor verifique.');
                    return false;
                }

            }
                    
        });
        
        
        $(".exportar_productos").click(function() {
            
            $('.parametros').html(
                '<input name="tipo_gtin" type="hidden" value="'+$('tfoot tr th:nth-child(1) span input').val()+'">'+
                '<input name="gtin" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="marca" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="codigo_producto" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
                '<input name="fecha_creacion" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
                '<input name="fecha_modificacion" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'
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

        // Validacion del formualrio trasnferir productos
        $('#formulario_transferir_productos').submit(function( event ) { 

             if ($(".transferir_producto_seleccionado:checked").length == 0)
            {
                
                alert("Estimado Usuario, no ha seleccionado ningún producto  para ser transferido. Por favor verifique.");
                return false;
            }

            if ($(".transferir_gtin_a_empresa:checked").length == 0)
            {
                
                alert("Estimado Usuario, no ha seleccionado ningúna a la que le serán transferidos los productos seleccionados. Por favor verifique.");
                return false;
            }

        });
        

});






