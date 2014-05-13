class GlnsDatatable < AjaxDatatablesRails
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
          empresa_gln.gln.gln,
          empresa_gln.try(:gln).try(:tipo_gln).try(:nombre),
          empresa_gln.try(:gln).try(:codigo_localizacion),
          empresa_gln.try(:gln).try(:descripcion),
          empresa_gln.try(:gln).try(:estatus).try(:descripcion),
          empresa_gln.try(:gln).try(:fecha_asignacion).strftime("%Y-%m-%d"),
          empresa_gln.try(:gln).try(:estado).try(:nombre),
          empresa_gln.try(:gln).try(:id_municipio),
          empresa_gln.try(:gln).try(:ciudad).try(:nombre),
          link_to("Editar", "/empresas/#{params[:empresa_id]}/glns/#{empresa_gln.gln.gln}/edit"),
          link_to("Ver Detalle", "/empresas/#{params[:empresa_id]}/glns/#{empresa_gln.gln.gln}"),
          
        ]
    end

  end

  def glns
    glns ||= fetch_glns
  end

  def fetch_glns

    glns = GlnEmpresa.where("gln_empresa.prefijo = ?", params[:empresa_id]).includes(:gln,  :empresa) 
    
    glns = glns.page(page).per_page(per_page)

   

    
    # if params[:sSearch].present? # Filtro de busqueda general
    #   productos = productos.where("empresa.nombre_empresa like :search or tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or producto.gpc like :search or estatus.descripcion like :search or estatus.descripcion like :search or producto.codigo_prod like :search ", search: "%#{params[:sSearch]}%")
    # end
    
    # if params[:sSearch_0].present? # Filtro de busqueda Nombre de la Empresa
    #   productos = productos.where("empresa.nombre_empresa like :search0", search0: "%#{params[:sSearch_0]}%" )
    # end
    
    # if params[:sSearch_1].present? # Filtro de busqueda por Tipo GTIN
    #   productos = productos.where("tipo_gtin.tipo like :search1", search1: "%#{params[:sSearch_1]}%" )
    # end

    # if params[:sSearch_2].present? # Filtro GTIN
    #   productos = productos.where("producto.gtin like :search2", search2: "%#{params[:sSearch_2]}%" )
    # end
    
    # if params[:sSearch_3].present?
    #   productos = productos.where("producto.descripcion like :search3", search3: "%#{params[:sSearch_3]}%" )
    # end

    # if params[:sSearch_4].present?
    #   productos = productos.where("producto.marca like :search4", search4: "%#{params[:sSearch_4]}%" )
    # end

    # if params[:sSearch_5].present?
    #   productos = productos.where("producto.gpc like :search5", search5: "%#{params[:sSearch_5]}%" )
    # end

    # if params[:sSearch_6].present?
    #   productos = productos.where("estatus.descripcion like :search6", search6: "%#{params[:sSearch_6]}%")
    # end

    # if params[:sSearch_7].present?
    #   productos = productos.where("producto.codigo_prod like :search7", search7: "%#{params[:sSearch_7]}%" )
    # end

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