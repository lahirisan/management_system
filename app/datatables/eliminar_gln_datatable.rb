# encoding: UTF-8
class EliminarGlnDatatable 
  delegate :params, :h, :link_to, :content_tag, :check_box_tag,  to: :@view

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

    glns.map do |gln|
      
        [ 
          check_box_tag("eliminar_glns[]", "#{gln.gln}", false, :class=>"eliminar_gln"),
          gln.gln,
          gln.try(:tipo_gln).try(:nombre),
          gln.try(:codigo_localizacion),
          gln.try(:descripcion),
          gln.try(:fecha_asignacion),
          gln.try(:estado),
          gln.try(:municipio),
          gln.try(:ciudad),
          gln.try(:estatus).try(:descripcion),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, "/empresas/#{params[:empresa_id]}/glns/#{gln.gln}",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle del GLN #{gln.gln}"})
          
          
        ]
    end

  end

  def glns
    glns ||= fetch_glns
  end

  def fetch_glns

    glns = Gln.where("prefijo = ? and tipo_gln.nombre in (?)", params[:empresa_id], ['Operativo','Físico']).joins(:tipo_gln,  :estatus).order("#{sort_column} #{sort_direction}")  
    glns = glns.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      glns = glns.where("gln like :search or tipo_gln.nombre like :search or codigo_localizacion like :search or gln.descripcion like :search or gln.fecha_asignacion like :search or estados.nombre like :search or municipio.nombre like :search or estatus.descripcion like :search or ciudad.nombre like :search ", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_1].present? # Filtro de busqueda por GLN
      glns = glns.where("gln.gln like :search1", search1: "%#{params[:sSearch_1]}%" )
    end

    if params[:sSearch_2].present? # Filtro de busqueda por Tipo GTIN
      glns = glns.where("tipo_gln.nombre like :search2", search2: "%#{params[:sSearch_2]}%" )
    end

    if params[:sSearch_3].present? # Filtro GTIN
      glns = glns.where("gln.codigo_localizacion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    
    if params[:sSearch_4].present?
      glns = glns.where("gln.descripcion like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_5].present?
      glns = glns.where("gln.fecha_asignacion like :search5", search5: "%#{params[:sSearch_5]}%" )
    end

    if params[:sSearch_6].present?
      glns = glns.where("estados.nombre like :search6", search6: "%#{params[:sSearch_6]}%")
    end

    if params[:sSearch_7].present?
      glns = glns.where("municipio.nombre like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    if params[:sSearch_8].present?
      glns = glns.where("ciudad.nombre like :search8", search8: "%#{params[:sSearch_8]}%" )
    end

    if params[:sSearch_9].present?
      glns = glns.where("estatus.descripcion like :search9", search9: "%#{params[:sSearch_9]}%" )
    end


    glns
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    prueba =params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[gln.gln tipo_gln.nombre gln.codigo_localizacion gln.descripcion estatus.descripcion gln.fecha_asignacion estados.nombre municipio.nombre ciudad.nombre]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end