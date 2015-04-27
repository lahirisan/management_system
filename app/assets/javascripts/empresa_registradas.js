$( document ).ready(function() {
	
	// Datatable que maneja el listado de empresas

    $("#data_table_empresa_registradas").dataTable({
        sPaginationType: "full_numbers",
        bJQueryUI: true,
        aaSorting: [[ 2, "desc" ]],
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',
        sAjaxSource: $('#data_table_empresa_registradas').data('source')
    }).columnFilter({ aoColumns: [{ type: "text"}, { type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"} , {type: "text"}]});;


	$('#empresa_registrada_ventas_brutas_anuales').change(function() {

		if (($(this).val() == '0 a 100.000') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
			$('#empresa_registrada_aporte_mantenimiento_bs').val('5500.00');
		if (($(this).val() == 'De 100.001,00 a 2.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('9000.00');
		if (($(this).val() == 'De 2.000.001,00 a 6.500.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('20000.00');
		if (($(this).val() == 'De 6.500.001,00 a 8.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('35000.00');
		if (($(this).val() == 'De 8.000.0001,00 o más') && ($('#empresa_registrada_id_tipo_usuario').val()== '1'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('44000.00');

		if (($(this).val() == '0 a 100.000') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
			$('#empresa_registrada_aporte_mantenimiento_bs').val('5500.00');
		if (($(this).val() == 'De 100.001,00 a 2.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('5500.00');
		if (($(this).val() == 'De 2.000.001,00 a 6.500.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('7300.00');
		if (($(this).val() == 'De 6.500.001,00 a 8.000.000,00') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('12800.00');
		if (($(this).val() == 'De 8.000.0001,00 o más') && ($('#empresa_registrada_id_tipo_usuario').val()== '2'))
		 	$('#empresa_registrada_aporte_mantenimiento_bs').val('35000.00');

	});

	$("#data_table_empresa_registradas_activar_solvencia").dataTable({
        sPaginationType: "full_numbers",
        aoColumns: [ { "bSortable": false }, null,null, null, null, null, null],
        bJQueryUI: true,
        aaSorting: [[ 3, "desc" ]],
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',
        sAjaxSource: $('#data_table_empresa_registradas_activar_solvencia').data('source')
    }).columnFilter({ aoColumns: [null, { type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}]});

    $('.nuevo_registro_activar_solvencia').hover(
      function() { $(this).addClass('ui-state-hover'); },
      function() { $(this).removeClass('ui-state-hover');}
    );

    $('#activar_solvencia').submit(function( event ) {
            

            if ($(".activar_solvencia:checked").length == 0)
            {
                alert("Estimado usuario, no ha seleccionado ninguna nueva empresa para asignar como SOLVENTE. Por favor verifique.");
                return false;
            }

    });

     //  Manejador del evento Change del campo Clasificacion
        $( "#empresa_registrada_id_clasificacion").change(function() {
            $.get('/clasificaciones/'+$(this).val()+'.json', function( data ) {
                $('#empresa_registrada_categoria').val(data.categoria); // campo categoria formulario crear Empresa
                $('#empresa_registrada_division').val(data.division); // campo division formulario crear Empresa
                $('#empresa_registrada_grupo').val(data.grupo); // campo grupo formulario crear Empresa
                $('#empresa_registrada_clase').val(data.clase); // campo clase formulario crear Empresa
            });

        });

        $('#asignar_prefijo_manual').dialog({
          autoOpen: false,
          width: 900
         
        });

        // Botón para abrir el dialogo
        $('#boton_abrir_ventana_prefijo_manual').click(function(w){
          w.preventDefault(); // Deshabilita el hipervinculo el boton importar
          

          $('#prefijos_disponibles').dataTable({
            bDestroy: true,
            bJQueryUI: true,
            aaSorting: [[ 3, "asc" ]],

          });
          $('#asignar_prefijo_manual').dialog('open').attr('class', 'ventana_prefijo_manual');
          
        });



        //cierra la ventana para asignar prefijo manual
        $('#regresar_formulario_empresa').click(function(){
            $('.ventana_prefijo_manual').dialog('close');
            
        });

        // Accion del boton asignar prefijo en la ventana

        $('.boton_asignar_prefijo_manual').click(function(){

            if ($('#prefijo_manual').val() == '')
            {
                alert('Estimado usuario, no ha ingresado ningún PREFIJO para ser reutilizado');
            }
            else
            {
                $('#empresa_registrada_prefijo').val($('#prefijo_manual').val());
                $('.ventana_prefijo_manual').dialog('close');
            }

        });

         // Actualizar la ciudad dependiendo del estado seleccionado - Datos Basicos
        $( "#empresa_registrada_id_estado").change(function() {
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });
           

        });

        // Lod datos de correspondencia

        $( "#empresa_registrada_id_estado_ean").change(function() {
            
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad_ean");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });

            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
                var  municipios = $("#empresa_registrada_id_municipio_ean");
                municipios.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    municipios.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });       

        });


        $( "#empresa_registrada_id_estado_edi").change(function() {
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad_edi");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });

            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
                var  municipios = $("#empresa_registrada_id_municipio_edi");
                municipios.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    municipios.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });       

        });


        $( "#empresa_registrada_id_estado_mercadeo").change(function() {
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad_mercadeo");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });

            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
                var  municipios = $("#empresa_registrada_id_municipio_mercadeo");
                municipios.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    municipios.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });       

        });

        $( "#empresa_registrada_id_estado_recursos").change(function() {
            
            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/ciudades.json?id_estado="+$(this).val(), function( data ) { 
                var ciudades = $("#empresa_registrada_id_ciudad_recursos");
                ciudades.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    ciudades.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });

            //AJAX que obtiene las ciudades dependiendo Que cumplen la condicion del estado seleccioando
            $.get("/municipios.json?id_estado="+$(this).val(), function( data ) { 
                var  municipios = $("#empresa_registrada_id_municipio_recursos");
                municipios.empty() // Se eliminan las opciones del select ciudades
                
                $.each( data, function( key, value ) {  // Se itera sobre las ciudades del estado seleccionado
                    municipios.append('<option value="'+ value.id +'">'+value.nombre+'</option>') // Se agregan las ciudades al select
                });
            });       

        });

        // Datepicker de la fecha

        if (window.location.pathname.split('/')[3] != 'edit')
        {
            // Datepicker los ultimos 100 anhos
            $("#empresa_registrada_fecha_registro_mercantil").datepicker({yearRange: "-100:+0",
                changeYear: true});
        }

        

        function isValidRIF(RIF){
            var pattern_rif = new RegExp(/^([0-9]{5,8})-([0-9]{1})$/);
            return pattern_rif.test(RIF);
        }

        $('#empresa_registrada_rif').keyup(function() {

            if ($(this).val().length == 8)
            {
                $('#empresa_registrada_rif').val($(this).val() + '-');
            }

        });



        // validacion de lof formato del telefono

     
        $('#empresa_registrada_contacto_tlf1').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_contacto_tlf1').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_contacto_tlf2').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_contacto_tlf2').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_contacto_tlf3').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_contacto_tlf3').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_contacto_fax').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_contacto_fax').val($(this).val() + '-');
            }

        });


        $('#empresa_registrada_telefono1_ean').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono1_ean').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono2_ean').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono2_ean').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono3_ean').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono3_ean').val($(this).val() + '-');
            }

        });

        $('#empresa_registrada_fax_ean').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_fax_ean').val($(this).val() + '-');
            }

        });


        $('#empresa_registrada_telefono1_edi').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono1_edi').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono2_edi').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono2_edi').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono3_edi').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono3_edi').val($(this).val() + '-');
            }

        });

        $('#empresa_registrada_fax_edi').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_fax_edi').val($(this).val() + '-');
            }

        });

        $('#empresa_registrada_telefono1_recursos').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono1_recursos').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono2_recursos').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono2_recursos').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono3_recursos').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono3_recursos').val($(this).val() + '-');
            }

        });

        $('#empresa_registrada_fax_recursos').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_fax_recursos').val($(this).val() + '-');
            }

        });

        $('#empresa_registrada_telefono1_mercadeo').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono1_mercadeo').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono2_mercadeo').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono2_mercadeo').val($(this).val() + '-');
            }
           

        });

        $('#empresa_registrada_telefono3_mercadeo').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_telefono3_mercadeo').val($(this).val() + '-');
            }

        });

        $('#empresa_registrada_fax_mercadeo').keyup( function() {
            
            if (($(this).val().length == 3) ||  ($(this).val().length == 6))
            {
                $('#empresa_registrada_fax_mercadeo').val($(this).val() + '-');
            }

        });




        $('#formulario_crear_empresa').submit(function( event ) {

            if ($('#empresa_registrada_tipo_rif').val() == '')
                {
                    alert('Estimado usuario, debe seleccionar el Tipo de RIF para poder continuar (J,G,E,V)');
                    return false;
                }
           
        });

        // boton que repite la correspondencia

        $('#repetir_correspondencia').click(function(w){

            $('#empresa_registrada_rep_edi').val($('#empresa_registrada_rep_ean').val());
            $('#empresa_registrada_rep_recursos').val($('#empresa_registrada_rep_ean').val());
            $('#empresa_registrada_rep_mercadeo').val($('#empresa_registrada_rep_ean').val());

            $('#empresa_registrada_rep_edi_cargo').val($('#empresa_registrada_rep_ean_cargo').val());
            $('#empresa_registrada_rep_recursos_cargo').val($('#empresa_registrada_rep_ean_cargo').val());
            $('#empresa_registrada_rep_mercadeo_cargo').val($('#empresa_registrada_rep_ean_cargo').val());

            $('#empresa_registrada_tipo_galpon_edificio_quinta_sincronet').val($('#empresa_registrada_tipo_galpon_edificio_quinta').val());
            $('#empresa_registrada_galpon_edificio_quinta_sincronet').val($('#empresa_registrada_galpon_edificio_quinta').val());
            $('#empresa_registrada_tipo_piso_numero_sincronet').val($('#empresa_registrada_tipo_piso_numero').val());
            $('#empresa_registrada_piso_numero_sincronet').val($('#empresa_registrada_piso_numero').val());
            $('#empresa_registrada_tipo_oficina_apartamento_sincronet').val($('#empresa_registrada_tipo_oficina_apartamento').val());
            $('#empresa_registrada_oficina_apartamento_sincronet').val($('#empresa_registrada_oficina_apartamento').val());
            $('#empresa_registrada_tipo_avenida_calle_sincronet').val($('#empresa_registrada_tipo_avenida_calle').val());
            $('#empresa_registrada_avenida_calle_sincronet').val($('#empresa_registrada_avenida_calle').val());
            $('#empresa_registrada_tipo_urbanizacion_barrio_sector_sincronet').val($('#empresa_registrada_tipo_urbanizacion_barrio_sector').val());
            
            $('#empresa_registrada_urbanizacion_barrio_sector_sincronet').val($('#empresa_registrada_urbanizacion_barrio_sector').val());
            
            $('#empresa_registrada_id_estado_edi').val($('#empresa_registrada_id_estado_ean').val());
            
            $('#empresa_registrada_id_ciudad_edi').val($('#empresa_registrada_id_ciudad_ean').val());
            
            $('#empresa_registrada_id_municipio_edi').val($('#empresa_registrada_id_municipio_ean').val());
            
            $('#empresa_registrada_parroquia_edi').val($('#empresa_registrada_parroquia_ean').val());
            

            $('#empresa_registrada_punto_ref_edi').val($('#empresa_registrada_punto_ref_ean').val());
            
            $('#empresa_registrada_codigo_postal_edi').val($('#empresa_registrada_cod_postal_ean').val());
            
            $('#empresa_registrada_cod_tlf1_sincronet').val($('#empresa_registrada_cod_tlf1_ean').val());
            $('#empresa_registrada_cod_tlf1_seminarios').val($('#empresa_registrada_cod_tlf1_ean').val());
            $('#empresa_registrada_cod_tlf1_mercadeo').val($('#empresa_registrada_cod_tlf1_ean').val());

            $('#empresa_registrada_telefono1_edi').val($('#empresa_registrada_telefono1_ean').val());
            $('#empresa_registrada_telefono1_recursos').val($('#empresa_registrada_telefono1_ean').val());
            $('#empresa_registrada_telefono1_mercadeo').val($('#empresa_registrada_telefono1_ean').val());

            $('#empresa_registrada_cod_tlf2_sincronet').val($('#empresa_registrada_cod_tlf2_ean').val());
            
            $('#empresa_registrada_telefono2_edi').val($('#empresa_registrada_telefono2_ean').val());
            
            $('#empresa_registrada_cod_tlf3_sincronet').val($('#empresa_registrada_cod_tlf3_ean').val());
            
            $('#empresa_registrada_telefono3_edi').val($('#empresa_registrada_telefono3_ean').val());
            
            $('#empresa_registrada_cod_fax_sincronet').val($('#empresa_registrada_cod_fax_ean').val());
            $('#empresa_registrada_fax_edi').val($('#empresa_registrada_fax_ean').val());

            $('#empresa_registrada_cod_fax_seminarios').val($('#empresa_registrada_cod_fax_ean').val());
            $('#empresa_registrada_fax_recursos').val($('#empresa_registrada_fax_ean').val());

            $('#empresa_registrada_cod_fax_mercadeo').val($('#empresa_registrada_cod_fax_ean').val());
            $('#empresa_registrada_fax_mercadeo').val($('#empresa_registrada_fax_ean').val());
            
            $('#empresa_registrada_email1_edi').val($('#empresa_registrada_email1_ean').val());
            $('#empresa_registrada_email1_recursos').val($('#empresa_registrada_email1_ean').val());
            $('#empresa_registrada_email1_mercadeo').val($('#empresa_registrada_email1_ean').val());

            
        });


        // Ventana para activar empresa

        $('.activar_empresa').dialog({
          autoOpen: false,
          width: 900
         
        });

        // Botón para abrir el dialogo
        $('.boton_activar_empresa').click(function(w){
          w.preventDefault(); // 
         
          $('.activar_empresa').dialog('open');
          
        });

	
});