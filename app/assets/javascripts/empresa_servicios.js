$( document ).ready(function() {
	// Datatable que maneja el listado de servicios
    $("#data_table_empresa_servicios").dataTable({
        sPaginationType: "full_numbers",
        bJQueryUI: true,
        bProcessing: true,
        bServerSide: true,
        sDom: 'T<"clear">lfrtip',            
        sAjaxSource: $('#data_table_empresa_servicios').data('source')
    });

    $("#empresa_servicio_fecha_contratacion").datepicker();
    $("#empresa_servicio_fecha_finalizacion").datepicker();

});
