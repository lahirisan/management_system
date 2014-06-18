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
        empresa_servicio.empresa.nombre_empresa,
        label_tag("#{empresa_servicio.servicio.nombre}", nil, :class => "clase#{empresa_servicio.id}"),
        empresa_servicio.fecha_contratacion.strftime("%Y-%m-%d"),
        empresa_servicio.fecha_finalizacion.strftime("%Y-%m-%d"),
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
   
    empresa_servicios = EmpresaServicio.where("empresa_servicios.prefijo = ?", params[:empresa_id]).includes(:servicio, :empresa).order("#{sort_column} #{sort_direction}") 
    empresa_servicios = empresa_servicios.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresa_servicios = empresa_servicios.where("servicios.nombre like :search  or empresa_servicios.fecha_contratacion like :search or empresa_servicios.fecha_finalizacion like :search or empresa_servicios.nombre_contacto like :search or empresa_servicios.cargo_contacto like :search or empresa_servicios.telefono like :search or empresa_servicios.email like :search", search: "%#{params[:sSearch]}%")
    end
    

    if params[:sSearch_2].present? # Filtro de busqueda por Tipo GTIN
      empresa_servicios = empresa_servicios.where("servicios.nombre like :search2", search2: "%#{params[:sSearch_2]}%" )
    end

    if params[:sSearch_3].present? # Filtro GTIN
      empresa_servicios = empresa_servicios.where("empresa_servicios.fecha_contratacion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    
    if params[:sSearch_4].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.fecha_finalizacion like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_5].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.nombre_contacto like :search5", search5: "%#{params[:sSearch_5]}%" )
     end

    if params[:sSearch_6].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.cargo_contacto like :search6", search6: "%#{params[:sSearch_6]}%" )
     end

    if params[:sSearch_7].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.telefono like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    if params[:sSearch_8].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.email like :search8", search8: "%#{params[:sSearch_8]}%" )
    end

    
    empresa_servicios
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[servicios.nombre empresa_servicios.fecha_contratacion empresa_servicios.fecha_finalizacion empresa_servicios.nombre_contacto empresa_servicios.cargo_contacto empresa_servicios.telefono empresa_servicios.email]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end