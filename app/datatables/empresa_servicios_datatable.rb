class EmpresaServiciosDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

   def initialize(view)
    @view = view


   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: empresa_servicios.count,
      iTotalDisplayRecords: empresa_servicios.total_entries,      
      aaData: data
    }

  end

private

  def data

    empresa_servicios.map do |empresa_servicio|
        
        [
          empresa_servicio.prefijo,
          empresa_servicio.servicio.nombre,
          empresa_servicio.fecha_contratacion,
          empresa_servicio.fecha_finalizacion,
          empresa_servicio.nombre_contacto,
          empresa_servicio.cargo_contacto,
          empresa_servicio.telefono,
          empresa_servicio.email,
          link_to("Editar", "/empresas/#{params[:empresa_id]}/empresa_servicios/#{empresa_servicio.id}/edit")
          
        ]
      
    end

  end

  def empresa_servicios
    empresa_servicios ||= fetch_empresa_servicios
  end

  def fetch_empresa_servicios

    empresa_servicios = EmpresaServicio.where("prefijo = ?", params[:empresa_id]).includes(:servicio)
    empresa_servicios = empresa_servicios.page(page).per_page(per_page)
    
    # if params[:sSearch].present? # Filtro de busqueda general
    #   productos = productos.where("empresa_servicios like :search  or servicio.", search: "%#{params[:sSearch]}%")
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