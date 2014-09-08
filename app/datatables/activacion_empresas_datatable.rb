class ActivacionEmpresasDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to, :check_box_tag,   to: :@view

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
        check_box_tag("activar_empresas[]", "#{empresa.id}", false, :class => "activar_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        fecha,
        empresa.ciudad.nombre,
        empresa.rif,
        empresa.estatus.descripcion.upcase,
        empresa.try(:ventas_brutas_anuales),
        empresa.try(:clasificacion).try(:descripcion) 
       
      ]

    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
    empresas = Empresa.where("estatus.descripcion like ?", "No Validado").includes(:estado, :ciudad, :estatus, :clasificacion).order("#{sort_column} #{sort_direction}")
    empresas = empresas.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or ciudad.nombre like :search or empresa.rif like :search or empresa_clasificacion.descripcion like :search ", search: "%#{params[:sSearch]}%")
    end
    if params[:sSearch_1].present? # Filtro de busqueda por nombre de la empresa
       empresas = empresas.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    if params[:sSearch_2].present? # Filtro fecha_inscripcion
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
    if params[:sSearch_7].present?
      empresas = empresas.where("empresa.ventas_brutas_anuales like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    if params[:sSearch_8].present?
      empresas = empresas.where("empresa_clasificacion.descripcion like :search8", search8: "%#{params[:sSearch_8]}%" )
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

     columns = %w[nil empresa.prefijo empresa.nombre_empresa empresa.fecha_inscripcion ciudad.nombre empresa.rif estatus.descripcion empresa.ventas_brutas_anuales empresa_clasificacion.descripcion]
     columns[params[:iSortCol_0].to_i]

  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end