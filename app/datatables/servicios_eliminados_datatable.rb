class ServiciosEliminadosDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

   def initialize(view)
    @view = view
   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: empresa_servicios_eliminados.count,
      iTotalDisplayRecords: empresa_servicios_eliminados.total_entries,      
      aaData: data
    }

  end

private

  def data

    empresa_servicios_eliminados.map do |empresa_servicio_eliminado|
        
        [
          empresa_servicio_eliminado.prefijo,
          empresa_servicio_eliminado.servicio.nombre,
          empresa_servicio_eliminado.fecha_contratacion,
          empresa_servicio_eliminado.fecha_finalizacion,
          empresa_servicio_eliminado.nombre_contacto,
          empresa_servicio_eliminado.cargo_contacto,
          empresa_servicio_eliminado.telefono,
          empresa_servicio_eliminado.email,
          empresa_servicio_eliminado.motivo_retiro.descripcion,
          empresa_servicio_eliminado.sub_estatus.descripcion,
          empresa_servicio_eliminado.fecha_eliminacion
        ]
      
    end

  end

  def empresa_servicios_eliminados
    empresa_servicios ||= fetch_empresa_servicios_eliminados
  end

  def fetch_empresa_servicios_eliminados

    empresa_servicios = EmpresaServiciosEliminado.where("prefijo = ?", params[:prefijo]).includes(:servicio)
    empresa_servicios = empresa_servicios.page(page).per_page(per_page)
    
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

    empresa_servicios
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.nombre_empresa tipo_gtin.tipo producto.gtin producto.descripcion producto.marca producto.gpc estatus.descripcion producto.codigo_prod like]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end