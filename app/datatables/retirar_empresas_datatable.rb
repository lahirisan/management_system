class RetirarEmpresasDatatable < AjaxDatatablesRails
  delegate :params, :h,  :link_to, :check_box_tag, :try, :select_tag, :options_from_collection_for_select,  to: :@view

   def initialize(view)
    @view = view

   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: empresas.count,
      iTotalDisplayRecords: empresas.total_entries,      
      aaData: data
    }

  end

private

  def data

    empresas.map do |empresa|
      
      fecha = ""
      fecha =  empresa.fecha_inscripcion.strftime("%Y-%m-%d") if (empresa.fecha_inscripcion)

      [ 
        check_box_tag("retirar_empresas[]", "#{empresa.id}", false, :class=>"retirar_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        fecha,
        empresa.ciudad.nombre,
        empresa.rif,
        empresa.estatus.descripcion,
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa, :retirar => true), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, empresa_productos_path(empresa), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe,  "/empresas/#{empresa.prefijo}/empresa_servicios",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa),  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociado a la empresa #{empresa.nombre_empresa}"}),
        select_tag("sub_estatus", options_from_collection_for_select(SubEstatus.all, "id", "descripcion", empresa.empresas_retiradas.try(:id_subestatus)), :id => "#{empresa.prefijo}sub_estatus"),
        select_tag("motivo_retiro", options_from_collection_for_select(MotivoRetiro.all, "id", "descripcion", empresa.empresas_retiradas.try(:id_motivo_retiro)), :id => "#{empresa.prefijo}motivo_ret")
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
   
    empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, :empresas_retiradas).where("estatus.descripcion like ? and alcance like ?", 'Activa', 'Empresa').order("#{sort_column} #{sort_direction}")
   
    
    empresas = empresas.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.prefijo like :search or empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or ciudad.nombre like :search or empresa.rif like :search or estatus.descripcion like :search or empresa.id_tipo_usuario like :search or empresa.nombre_comercial like :search or empresa.id_clasificacion like :search or empresa.categoria like :search or empresa.division like :search or empresa.grupo like :search or empresa.clase like :search or empresa.rep_legal like :search or empresa.cargo_rep_legal like :search", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_1].present? # Filtro de busqueda por prefijo
       empresas = empresas.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" )
      
    end
    if params[:sSearch_2].present? # Filtro nombre empresa
      empresas = empresas.where("empresa.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    if params[:sSearch_3].present?
      empresas = empresas.where("empresa.fecha_inscripcion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    if params[:sSearch_4].present?
      empresas = empresas.where("ciudad.nombre like :search4", search4: "%#{params[:sSearch_4]}%" )
    end
    if params[:sSearch_5].present?
      empresas = empresas.where("empresa.rif like :search5", search5: "%#{params[:sSearch_5]}%" )
    end
    if params[:sSearch_6].present?
      empresas = empresas.where("estatus.descripcion like :search6", search6: "%#{params[:sSearch_6]}%" )
    end
    if params[:sSearch_7].present?
      empresas = empresas.where("empresa.id_tipo_usuario like :search7", search7: "%#{params[:sSearch_7]}%" )
    end
    if params[:sSearch_8].present?
      empresas = empresas.where("empresa.nombre_comercial like :search8", search8: "%#{params[:sSearch_8]}%" )
    end
    if params[:sSearch_9].present?
      empresas = empresas.where("empresa.id_clasificacion like :search9", search9: "%#{params[:sSearch_9]}%" )
    end
    if params[:sSearch_10].present?
      empresas = empresas.where("empresa.categoria like :search10", search10: "%#{params[:sSearch_10]}%" )
    end
    if params[:sSearch_11].present?
      empresas = empresas.where("empresa.division like :search11", search11: "%#{params[:sSearch_11]}%" )
    end
    if params[:sSearch_12].present?
      empresas = empresas.where("empresa.grupo like :search12", search12: "%#{params[:sSearch_12]}%" )
    end
    if params[:sSearch_13].present? 
      empresas = empresas.where("empresa.clase like :search13", search13: "%#{params[:sSearch_13]}%" )
    end
    if params[:sSearch_14].present?
      empresas = empresas.where("empresa.rep_legal like :search14", search14: "%#{params[:sSearch_14]}%" )
    end
    if params[:sSearch_15].present?
      empresas = empresas.where("empresa.cargo_rep_legal like :search15", search15: "%#{params[:sSearch_15]}%" )
    end
    empresas
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.prefijo empresa.nombre_empresa empresa.fecha_inscripcion empresa.direccion_empresa estados.nombre ciudad.nombre empresa.rif  estatus.descripcion empresa.id_tipo_usuario empresa.nombre_comercial empresa.id_clasificacion empresa.categoria empresa.division empresa.grupo empresa.clase empresa.rep_legal empresa.cargo_rep_legal]
     columns[params[:iSortCol_0].to_i]
     
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  
end