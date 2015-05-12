  $( document ).ready(function() {
        // DELAY FILTER
       
       /*
       jQuery.fn.dataTableExt.oApi.fnSetFilteringDelay = function ( oSettings, iDelay ) {
            var _that = this;

            if ( iDelay === undefined ) {
                iDelay = 500;
            }

            this.each( function ( i ) {
                $.fn.dataTableExt.iApiIndex = i;
                var
                    $this = this,
                    oTimerId = null,
                    sPreviousSearch = null,
                    anControl = $( 'input', _that.fnSettings().aanFeatures.f );

                    anControl.unbind( 'keyup search input' ).bind( 'keyup search input', function() {
                    var $$this = $this;

                    if (sPreviousSearch === null || sPreviousSearch != anControl.val()) {
                        window.clearTimeout(oTimerId);
                        sPreviousSearch = anControl.val();
                        oTimerId = window.setTimeout(function() {
                            $.fn.dataTableExt.iApiIndex = i;
                            _that.fnFilter(anControl.val());
                        }, iDelay);
                    }
                });

                return this;
            } );
            return this;
        };

        */

        // FILTER ON RETURN

        jQuery.fn.dataTableExt.oApi.fnFilterOnReturn = function (oSettings) {
        var _that = this;
 
        this.each(function (i) {
            $.fn.dataTableExt.iApiIndex = i;
            var $this = this;
            var anControl = $('input', _that.fnSettings().aanFeatures.f);
            anControl
                .unbind('keyup search input')
                .bind('keypress', function (e) {
                    if (e.which == 13) {
                        $.fn.dataTableExt.iApiIndex = i;
                        _that.fnFilter(anControl.val());
                    }   
                });
            return this;
        });
        return this;
        };

      
       oTable1 =  $("#data_table_reporte_empresas").dataTable({
            bStateSave: true,
            sPaginationType: "full_numbers",
            aaSorting: [[ 2, "desc" ]],
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',
            sAjaxSource: $('#data_table_reporte_empresas').data('source')
        });


       oTable1.columnFilter({ aoColumns: [{ type: "text"}, {type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, null, {type: "text"}, {type: "text"}]});
       oTable1.fnFilterOnReturn();

        



        $('#data_table_reporte_empresas input').attr("placeholder", "Buscar");


    oTable = $("#data_table_reporte_productos").dataTable({
        sPaginationType: "full_numbers",
        aaSorting: [[ 1, "asc" ]],
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_reporte_productos').data('source')
    });
   
    oTable.columnFilter({ aoColumns: [{ type: "text"},{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"},{type: "text"},{type: "text"}]});

    oTable.fnFilterOnReturn();

        /*
            var search_timeout = undefined;
            //col filter
            $("tfoot input").keyup( function () {
            if(search_timeout != undefined) {
                clearTimeout(search_timeout);
              }
            $this = this;
                search_timeout = setTimeout(function() {
                search_timeout = undefined;
                oTable.fnFilter( $this.value, $("tfoot input").index($this) );
                }, 1000);
            } );

        */

    oTable2 = $("#data_table_reporte_glns").dataTable({
        sPaginationType: "full_numbers",
        aaSorting: [[ 1, "asc" ]],
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_reporte_glns').data('source')
    });
   
    oTable2.columnFilter({ aoColumns: [{ type: "text"},{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});
    oTable2.fnFilterOnReturn();


     oTable2 = $("#data_table_reporte_servicios").dataTable({
        sPaginationType: "full_numbers",
        aaSorting: [[ 1, "asc" ]],
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_reporte_servicios').data('source')
    });
   
    oTable2.columnFilter({ aoColumns: [{ type: "text"},{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});
    oTable2.fnFilterOnReturn();

      $('.exportar_reporte_servicios, .exportar_reporte_productos, .exportar_reporte_gln').hover(
          function() { $(this).addClass('ui-state-hover'); },
          function() { $(this).removeClass('ui-state-hover');}
        );


    $(".exportar_reporte_productos").click(function() {
            
        $('.parametros').html(
            '<input name="nombre_empresa" type="hidden" value="'+$('tfoot tr th:nth-child(1) span input').val()+'">'+
            '<input name="prefijo" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
            '<input name="tipo_gtin" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
            '<input name="gtin" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
            '<input name="descripcion" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
            '<input name="marca" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
            '<input name="estatus" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
            '<input name="codigo_producto" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
            '<input name="fecha_creacion" type="hidden" value="'+$('tfoot tr th:nth-child(9) span input').val()+'">'+
            '<input name="filtro_general" type="hidden" value="'+$("#data_table_reporte_productos_filter label input").val()+'">'+
            '<input name="reporte_producto" type="hidden" value="true">'+
            '<input name="fecha_modificacion" type="hidden" value="'+$('tfoot tr th:nth-child(10) span input').val()+'">'
        );
    });

  $(".exportar_reporte_gln").click(function() {
            
        $('.parametros').html(
            '<input name="nombre_empresa" type="hidden" value="'+$('tfoot tr th:nth-child(1) span input').val()+'">'+
            '<input name="prefijo" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
            '<input name="gln" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
            '<input name="tipo_gln" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
            '<input name="codigo_localizacion" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
            '<input name="estatus" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
            '<input name="estado" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
            '<input name="ciudad" type="hidden" value="'+$('tfoot tr th:nth-child(8) span input').val()+'">'+
            '<input name="reporte_gln" type="hidden" value="true">'
        );
    });

    $(".exportar_reporte_servicios").click(function() {
            
        $('.parametros').html(
            '<input name="nombre_empresa" type="hidden" value="'+$('tfoot tr th:nth-child(1) span input').val()+'">'+
            '<input name="prefijo" type="hidden" value="'+$('tfoot tr th:nth-child(2) span input').val()+'">'+
            '<input name="estatus" type="hidden" value="'+$('tfoot tr th:nth-child(3) span input').val()+'">'+
            '<input name="clasificacion" type="hidden" value="'+$('tfoot tr th:nth-child(4) span input').val()+'">'+
            '<input name="servicio" type="hidden" value="'+$('tfoot tr th:nth-child(5) span input').val()+'">'+
            '<input name="fecha_contratacion" type="hidden" value="'+$('tfoot tr th:nth-child(6) span input').val()+'">'+
            '<input name="fecha_finalizacion" type="hidden" value="'+$('tfoot tr th:nth-child(7) span input').val()+'">'+
            '<input name="reporte_servicio" type="hidden" value="true">'
        );
    });



});