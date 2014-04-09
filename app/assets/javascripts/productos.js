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
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});

        // Datatable que maneja retirar productos
        $("#data_table_productos_retirados").dataTable({
            sPaginationType: "full_numbers",
            bJQueryUI: true,
            bProcessing: true,
            bServerSide: true,
            sDom: 'T<"clear">lfrtip',            
            sAjaxSource: $('#data_table_productos_retirados').data('source')
        }).columnFilter({ aoColumns: [{ type: "text"}, {type: "text" }, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}, {type: "text"}]});


    })   

