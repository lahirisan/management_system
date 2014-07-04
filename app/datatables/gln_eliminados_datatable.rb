class GlnEliminadosDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

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
          empresa_gln.try(:gln_eliminado).try(:gln),
          empresa_gln.try(:gln_eliminado).try(:tipo_gln).try(:nombre),
          empresa_gln.try(:gln_eliminado).try(:codigo_localizacion),
          empresa_gln.try(:gln_eliminado).try(:descripcion),
          empresa_gln.try(:gln_eliminado).try(:fecha_asignacion).strftime("%Y-%m-%d"),
          empresa_gln.try(:gln_eliminado).try(:estado).try(:nombre),
          empresa_gln.try(:gln_eliminado).try(:ciudad).try(:nombre),
          empresa_gln.try(:gln_eliminado).try(:municipio).try(:nombre),
          empresa_gln.try(:gln_eliminado).try(:fecha_eliminacion).strftime("%Y-%m-%d"),
          empresa_gln.try(:gln_eliminado).try(:estatus).try(:descripcion),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe,"/empresas/#{params[:empresa_id]}/glns/#{empresa_gln.gln_eliminado.gln}?eliminado=true",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle del GLN #{empresa_gln.try(:gln_eliminado).try(:gln)}"}),
          empresa_gln.try(:gln_eliminado).try(:sub_estatus).try(:descripcion),
          empresa_gln.try(:gln_eliminado).try(:motivo_retiro).try(:descripcion)
        ]
    end

  end

  def glns
    glns ||= fetch_glns
  end

  def fetch_glns

    # Se verifica si la empresa esta eliminada
    empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]]) # Se busca en las empresas activas o retiradas

    if empresa

      glns = GlnEmpresa.where("gln_empresa.prefijo = ?", params[:empresa_id]).joins({:gln_eliminado => :tipo_gln} ,{:gln_eliminado => :estado}, {:gln_eliminado => :municipio}, {:gln_eliminado => :ciudad}, :empresa)

    else
        glns = GlnEmpresa.where("gln_empresa.prefijo = ?", params[:empresa_id]).joins({:gln_eliminado => :tipo_gln} ,{:gln_eliminado => :estado}, {:gln_eliminado => :municipio}, {:gln_eliminado => :ciudad}, :empresa_eliminada)
    end
    
    glns = glns.page(page).per_page(per_page)

    
    # if params[:sSearch].present? # Filtro de busqueda general
    #   productos = productos.where("empresa.nombre_empresa like :search or tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or producto.gpc like :search or estatus.descripcion like :search or estatus.descripcion like :search or producto.codigo_prod like :search ", search: "%#{params[:sSearch]}%")
    # end
    
    if params[:sSearch_0].present? # Filtro de busqueda por GLN
      glns = glns.where("gln_eliminado.gln like :search0", search0: "%#{params[:sSearch_0]}%" )
    end

    if params[:sSearch_1].present? # Filtro de busqueda por Tipo GTIN
      glns = glns.where("tipo_gln.nombre like :search1", search1: "%#{params[:sSearch_1]}%" )
    end

    if params[:sSearch_2].present? # Filtro GTIN
      glns = glns.where("gln_eliminado.codigo_localizacion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    
    if params[:sSearch_3].present?
      glns = glns.where("gln_eliminado.descripcion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_4].present?
      glns = glns.where("gln_eliminado.fecha_asignacion like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_5].present?
      glns = glns.where("estados.nombre like :search5", search5: "%#{params[:sSearch_5]}%")
    end

    if params[:sSearch_7].present?
      glns = glns.where("municipio.nombre like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    if params[:sSearch_6].present?
      glns = glns.where("ciudad.nombre like :search6", search6: "%#{params[:sSearch_6]}%" )
    end

    if params[:sSearch_8].present?
      glns = glns.where("gln_eliminado.fecha_eliminacion like :search8", search8: "%#{params[:sSearch_8]}%" )
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

     columns = %w[empresa.nombre_empresa tipo_gtin.tipo producto.gtin producto.descripcion producto.marca producto.gpc estatus.descripcion producto.codigo_prod like]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end