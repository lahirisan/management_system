class ReporteGlnDatatable
  delegate :params, :h, :link_to, :content_tag,   to: :@view

   def initialize(view)
    @view = view
   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: glns.count,
      iTotalDisplayRecords: glns.total_entries,      
      aaData: data
    }

  end

private

  def data


    glns.map do |empresa_gln|
    

      [ 
      
        empresa_gln.nombre_empresa,
        empresa_gln.prefijo, 
        empresa_gln.gln_,
        empresa_gln.tipo_gln_,
        empresa_gln.codigo_localizacion,
        empresa_gln.estatus_,
        empresa_gln.estado_,
        empresa_gln.ciudad_
        
        
     
      ]
      
    end

  end

  def glns
    glns ||= fetch_glns
  end

  def fetch_glns

    glns = Gln.joins("INNER JOIN [empresa] ON [empresa].[prefijo] = [gln].[prefijo] left JOIN [estados] ON [estados].[id] = [empresa].[id_estado] inner JOIN [ciudad] ON [ciudad].[id] = [empresa].[id_ciudad] inner JOIN [estatus] ON [estatus].[id] = [gln].[id_estatus] INNER JOIN [tipo_gln] ON [tipo_gln].[id] = [gln].[id_tipo_gln]").select("empresa.nombre_empresa as nombre_empresa, empresa.prefijo as prefijo, gln.gln as gln_, tipo_gln.nombre as tipo_gln_, gln.codigo_localizacion as codigo_localizacion, estatus.descripcion as estatus_, estados.nombre as estado_, ciudad.nombre as ciudad_").order("#{sort_column} #{sort_direction}")
    
    glns = glns.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      glns = glns.where("gln like :search or tipo_gln.nombre like :search or gln.codigo_localizacion like :search or gln.descripcion like :search or estatus.descripcion like :search or gln.fecha_asignacion like :search or estados.nombre like :search or municipio.nombre like :search or ciudad.nombre like :search ", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_0].present? 
      glns = glns.where("empresa.nombre_empresa like :search0", search0: "%#{params[:sSearch_0]}%" )
    end

    if params[:sSearch_1].present? 
      glns = glns.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" )
    end

    if params[:sSearch_2].present? 
      glns = glns.where("gln like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    
    if params[:sSearch_3].present? 
      glns = glns.where("tipo_gln.nombre like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_4].present? 
      glns = glns.where("codigo_localizacion like :search4", search4: "%#{params[:sSearch_4]}%" )
    end
   
    if params[:sSearch_5].present?
      glns = glns.where("estatus.descripcion like :search5", search5: "%#{params[:sSearch_5]}%" )
    end

    if params[:sSearch_6].present?
      glns = glns.where("estados.nombre like :search6", search6: "%#{params[:sSearch_6]}%")
    end

    if params[:sSearch_7].present?
      glns = glns.where("ciudad.nombre like :search7", search7: "%#{params[:sSearch_7]}%" )
    end


    glns
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.nombre_empresa empresa.prefijo gln.gln tipo_gln.nombre gln.codigo_localizacion  estatus.descripcion  estados.nombre municipio.nombre ciudad.nombre gln.fecha_asignacion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end