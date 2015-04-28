$( document ).ready(function() {

        // Datatable que maneja el listado de glns
        $("#data_table_glns").dataTable({
            
            sPaginationType: "full_numbers",
            aaSorting: [[ 5, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_glns').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"},{ type: "text"}, {type: "text" }, {type: "text"}, null,{type: "text"} , {type: "text"}, {type: "text"}, {type: "text"}]});

        $('#data_table_glns input').attr("placeholder", "Buscar");


        // Datatable que maneja el listado de glns
        
        $("#data_table_eliminar_gln").dataTable({
            sPaginationType: "full_numbers",
            aaSorting: [[ 5, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_eliminar_gln').data('source')
        }).columnFilter({ aoColumns: [null,{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        $('#data_table_eliminar_gln input').attr("placeholder", "Buscar");

       

        // Efectos del boton importar
        $('.eliminar_gln, .exportar_gln, .exportar_gln_eliminar').hover(
          function() { $(this).addClass('ui-state-hover'); },
          function() { $(this).removeClass('ui-state-hover');}
        );

      
        // ELiminar masivo seleccionar / deseleccionar todos
        $('#eliminar_masivo_gln').live('change', function() {
            
            if ($(this).is(':checked'))
            {
                $('.eliminar_gln').prop('checked', true);
            }
            else 
            {
                $('.eliminar_gln').prop('checked', false);
            }  
            
        });

        // Formulario eliminar GLN

        $('#formulario_eliminar_gln').submit(function( event ) { 
            
            // Se valida que se haya seleccionado alguna empresa para retirar
            if ($(".eliminar_gln:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ningún GLN para ELIMINAR. Por favor verifique.");
                return false;
            }
            
            

            if (!(confirm('Esta seguro ELIMINAR los GLN seleccionados ?')))
                return false; 
            
        });

        // Manejo de la seleccion de estados municipios, ciudades

        $('#gln_estado').change(function() {

            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#gln_ciudad");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.nombre +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            })

            //AJAX que obtiene las municpios dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
                var municipios = $("#gln_municipio");
                municipios.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    municipios.append('<option value="'+ value.nombre +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            })

        });

        $(".exportar_gln").click(function() {
            $('.parametros').html(
                '<input name="gln" type="hidden" value="'+$('tfoot tr th:nth-child(1) span input').val()+'">'+
                '<input name="tipo_gln" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
                '<input name="codigo_localizacion" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="fecha_asignacion" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
                '<input name="estado" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
                '<input name="municipio" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
                '<input name="ciudad" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'
            );
        });

        $(".exportar_gln_eliminar").click(function() {
            $('.parametros').html(
                '<input name="gln" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
                '<input name="tipo_gln" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
                '<input name="codigo_localizacion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
                '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
                '<input name="fecha_asignacion" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
                '<input name="estado" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
                '<input name="municipio" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'+
                '<input name="ciudad" type="hidden" value="'+$('tfoot tr th:nth-child(10) span input').val()+'">'+
                '<input name="eliminar" type="hidden" value="eliminar">'
            );
        });
});