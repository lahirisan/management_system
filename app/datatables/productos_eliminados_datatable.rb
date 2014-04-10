class ProductosEliminadosDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

   def initialize(view)
    @view = view
   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: productos.count,
      iTotalDisplayRecords: productos.total_entries,      
      aaData: data
    }

  end

private

  def data

    productos.map do |producto|
      
        fecha = ""
        fecha =  producto.fecha_creacion.strftime("%Y-%m-%d") if (producto.fecha_creacion)
        [ 
        producto.try(:productos_empresa).try(:empresa).try(:nombre_empresa),
        producto.try(:tipo_gtin).try(:tipo),
        producto.gtin,
        producto.descripcion,
        producto.marca,
        producto.gpc,
        producto.try(:estatus).try(:descripcion),
        producto.codigo_prod,
        fecha
       
      ]
      
      

    end

  end

  def productos
    productos ||= fetch_productos
  end

  def fetch_productos
   
    productos = ProductoEliminado.where("estatus.descripcion like ? and estatus.alcance like ?", 'Eliminado', 'Producto').includes(:estatus, :tipo_gtin)
    productos = productos.page(page).per_page(per_page)
    
    # if params[:sSearch].present? # Filtro de busqueda general
    #   empresas = empresas.where("empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or empresa.direccion_empresa like :search or estados.nombre like :search or ciudad.nombre like :search or empresa.rif like :search or estatus.descripcion like :search or empresa.id_tipo_usuario like :search or empresa.nombre_comercial like :search or empresa.id_clasificacion like :search or empresa.categoria like :search or empresa.division like :search or empresa.grupo like :search or empresa.clase like :search or empresa.rep_legal like :search or empresa.cargo_rep_legal like :search", search: "%#{params[:sSearch]}%")
    # end
    # if params[:sSearch_0].present? # Filtro de busqueda prefijo
    #   empresas = empresas.where("empresa.prefijo like :search0", search0: "%#{params[:sSearch_0]}%" )
    # end
    # if params[:sSearch_1].present? # Filtro de busqueda por nombre de la empresa
    #   empresas = empresas.where("empresa.nombre_empresa like :search1", search1: "%#{params[:sSearch_1]}%" )
    # end
    # if params[:sSearch_2].present? # Filtro fecha_inscripcion
    #   empresas = empresas.where("empresa.fecha_inscripcion like :search2", search2: "%#{params[:sSearch_2]}%" )
    # end
    # if params[:sSearch_3].present?
    #   empresas = empresas.where("empresa.direccion_empresa like :search3", search3: "%#{params[:sSearch_3]}%" )
    # end
    # if params[:sSearch_4].present?
    #   empresas = empresas.where("estados.nombre like :search4", search4: "%#{params[:sSearch_4]}%" )
    # end
    # if params[:sSearch_5].present?
    #   empresas = empresas.where("ciudad.nombre like :search5", search5: "%#{params[:sSearch_5]}%" )
    # end
    # if params[:sSearch_6].present?
    #   empresas = empresas.where("empresa.rif like :search6", search6: "%#{params[:sSearch_6]}%" )
    # end
    # if params[:sSearch_7].present?
    #   empresas = empresas.where("estatus.descripcion like :search7", search7: "%#{params[:sSearch_7]}%" )
    # end
    # if params[:sSearch_8].present?
    #   empresas = empresas.where("empresa.id_tipo_usuario like :search8", search8: "%#{params[:sSearch_8]}%" )
    # end
    # if params[:sSearch_9].present?
    #   empresas = empresas.where("empresa.nombre_comercial like :search9", search9: "%#{params[:sSearch_9]}%" )
    # end
    # if params[:sSearch_10].present?
    #   empresas = empresas.where("empresa.id_clasificacion like :search10", search10: "%#{params[:sSearch_10]}%" )
    # end
    # if params[:sSearch_11].present?
    #   empresas = empresas.where("empresa.categoria like :search11", search11: "%#{params[:sSearch_11]}%" )
    # end
    # if params[:sSearch_12].present?
    #   empresas = empresas.where("empresa.division like :search12", search12: "%#{params[:sSearch_12]}%" )
    # end
    # if params[:sSearch_13].present?
    #   empresas = empresas.where("empresa.grupo like :search13", search13: "%#{params[:sSearch_13]}%" )
    # end
    # if params[:sSearch_14].present?
    #   empresas = empresas.where("empresa.clase like :search14", search14: "%#{params[:sSearch_14]}%" )
    # end
    # if params[:sSearch_15].present?
    #   empresas = empresas.where("empresa.rep_legal like :search15", search15: "%#{params[:sSearch_15]}%" )
    # end
    # if params[:sSearch_16].present?
    #   empresas = empresas.where("empresa.cargo_rep_legal like :search16", search16: "%#{params[:sSearch_16]}%" )
    # end
    
    #empresas
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