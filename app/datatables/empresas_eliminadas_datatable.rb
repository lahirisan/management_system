class EmpresasEliminadasDatatable < AjaxDatatablesRails
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
        check_box_tag("reactivar_empresas[]", "#{empresa.id}", false, :class=>"retirar_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        fecha,
        empresa.direccion_empresa,
        empresa.estado.nombre,
        empresa.ciudad.nombre,
        empresa.rif,
        empresa.estatus.descripcion,
        empresa.sub_estatus.descripcion,
        empresa.motivo_retiro.descripcion,
        link_to("Ver Detalle", empresa_path(empresa, :eliminados => true)),
        link_to("Productos", empresa_productos_path(empresa, :eliminados => true)),
        link_to("Servicios", "/empresas/#{empresa.prefijo}/empresa_servicios?eliminados=true"),
        link_to("GLN", empresa_glns_path(empresa, :eliminados => true))
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
   
    empresas = EmpresaEliminada.includes(:estado, :ciudad, :estatus, :clasificacion).order("#{sort_column} #{sort_direction}")
    
    empresas = empresas.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa_eliminada.nombre_empresa like :search or empresa_eliminada.fecha_inscripcion like :search or empresa_eliminada.direccion_empresa like :search or estados.nombre like :search or ciudad.nombre like :search or empresa_eliminada.rif like :search or estatus.descripcion like :search or empresa_eliminada.id_tipo_usuario like :search or empresa_eliminada.nombre_comercial like :search or empresa_eliminada.id_clasificacion like :search or empresa_eliminada.categoria like :search or empresa_eliminada.division like :search or empresa_eliminada.grupo like :search or empresa_eliminada.clase like :search or empresa_eliminada.rep_legal like :search or empresa_eliminada.cargo_rep_legal like :search", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_1].present? # Filtro de busqueda por nombre de la empresa
       empresas = empresas.where("empresa_eliminada.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" )
      
    end
    if params[:sSearch_2].present? # Filtro fecha_inscripcion
      empresas = empresas.where("empresa_eliminada.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    if params[:sSearch_3].present?
      empresas = empresas.where("empresa_eliminada.fecha_inscripcion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    if params[:sSearch_4].present?
      empresas = empresas.where("empresa_eliminada.direccion_empresa like :search4", search4: "%#{params[:sSearch_4]}%" )
    end
    if params[:sSearch_5].present?
      empresas = empresas.where("estados.nombre like :search5", search5: "%#{params[:sSearch_5]}%" )
    end
    if params[:sSearch_6].present?
      empresas = empresas.where("ciudad.nombre like :search6", search6: "%#{params[:sSearch_6]}%" )
    end
    if params[:sSearch_7].present?
      empresas = empresas.where("empresa_eliminada.rif like :search7", search7: "%#{params[:sSearch_7]}%" )
    end
    if params[:sSearch_8].present?
      empresas = empresas.where("estatus.descripcion like :search8", search8: "%#{params[:sSearch_8]}%" )
    end
    if params[:sSearch_9].present?
      empresas = empresas.where("empresa_eliminada.id_tipo_usuario like :search9", search9: "%#{params[:sSearch_9]}%" )
    end
    if params[:sSearch_10].present?
      empresas = empresas.where("empresa_eliminada.nombre_comercial like :search10", search10: "%#{params[:sSearch_10]}%" )
    end
    if params[:sSearch_11].present?
      empresas = empresas.where("empresa_eliminada.id_clasificacion like :search11", search11: "%#{params[:sSearch_11]}%" )
    end
    if params[:sSearch_12].present?
      empresas = empresas.where("empresa_eliminada.categoria like :search12", search12: "%#{params[:sSearch_12]}%" )
    end
    if params[:sSearch_13].present?
      empresas = empresas.where("empresa_eliminada.division like :search13", search13: "%#{params[:sSearch_13]}%" )
    end
    if params[:sSearch_14].present?
      empresas = empresas.where("empresa_eliminada.grupo like :search14", search14: "%#{params[:sSearch_14]}%" )
    end
    if params[:sSearch_15].present? 
      empresas = empresas.where("empresa_eliminada.clase like :search15", search15: "%#{params[:sSearch_15]}%" )
    end
    if params[:sSearch_16].present?
      empresas = empresas.where("empresa_eliminada.rep_legal like :search16", search16: "%#{params[:sSearch_16]}%" )
    end
    if params[:sSearch_17].present?
      empresas = empresas.where("empresa_eliminada.cargo_rep_legal like :search17", search17: "%#{params[:sSearch_17]}%" )
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

     columns = %w[empresa_eliminada.prefijo empresa_eliminada.nombre_empresa empresa_eliminada.fecha_inscripcion empresa_eliminada.direccion_empresa estados.nombre ciudad.nombre empresa_eliminada.rif  estatus.descripcion empresa_eliminada.id_tipo_usuario empresa_eliminada.nombre_comercial empresa_eliminada.id_clasificacion empresa_eliminada.categoria empresa_eliminada.division empresa_eliminada.grupo empresa_eliminada.clase empresa_eliminada.rep_legal empresa_eliminada.cargo_rep_legal]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end