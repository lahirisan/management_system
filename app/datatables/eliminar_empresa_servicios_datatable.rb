class EliminarEmpresaServiciosDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

   def initialize(view)
    @view = view
   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: servicios.count,
      iTotalDisplayRecords: servicios.total_entries,      
      aaData: data
    }

  end

private

  def data

    servicios.map do |empresa_servicio|
       
      [ 
        check_box_tag("eliminar_servicios[]", "#{empresa_servicio.id}", false, :class=>"eliminar_servicio"),
        empresa_servicio.prefijo,
        empresa_servicio.servicio.nombre,
        empresa_servicio.fecha_contratacion,
        empresa_servicio.fecha_finalizacion,
        empresa_servicio.nombre_contacto,
        empresa_servicio.cargo_contacto,
        empresa_servicio.telefono,
        empresa_servicio.email,
        select_tag("motivo_retiro", options_from_collection_for_select(MotivoRetiro.all, "id", "descripcion"), :id => "#{empresa_servicio.id}motivo_ret"),
        select_tag("sub_estatus", options_from_collection_for_select(SubEstatus.all, "id", "descripcion"), :id => "#{empresa_servicio.id}sub_estatus")
      ]

    end

  end

  def servicios
    servicios ||= fetch_servicios
  end

  def fetch_servicios
   
    empresa_servicios = EmpresaServicio.where("prefijo = ?", params[:prefijo]).includes(:servicio)
    empresa_servicios = empresa_servicios.page(page).per_page(per_page)
    empresa_servicios
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[producto.id_estatus]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end