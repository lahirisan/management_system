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
        nombre_empresa = (producto.try(:productos_empresa).try(:empresa_eliminada).try(:nombre_empresa)) ? producto.try(:productos_empresa).try(:empresa_eliminada).try(:nombre_empresa) : producto.try(:productos_empresa).try(:empresa).try(:nombre_empresa)
        [ 
        nombre_empresa,
        producto.try(:tipo_gtin).try(:tipo),
        producto.gtin,
        producto.descripcion,
        producto.marca,
        producto.try(:estatus).try(:descripcion),
        producto.codigo_prod,
        fecha,
        producto.try(:producto_elim_detalle).try(:fecha_eliminacion).strftime("%Y-%m-%d"),
        producto.try(:producto_elim_detalle).try(:sub_estatus).try(:descripcion),
        producto.try(:producto_elim_detalle).try(:motivo_retiro).try(:descripcion)

      ]
      
      

    end

  end

  def productos
    productos ||= fetch_productos
  end

  def fetch_productos
   
    productos = ProductoEliminado.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?", params[:empresa_id], 'Eliminado', 'Producto').includes(:estatus, :tipo_gtin, {:producto_elim_detalle => :sub_estatus}, {:producto_elim_detalle => :motivo_retiro}, {:productos_empresa => :empresa})
    productos = productos.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      productos = productos.where("empresa.nombre_empresa like :search or tipo_gtin.tipo like :search or producto_eliminado.gtin like :search or producto_eliminado.descripcion like :search or producto_eliminado.marca like :search or producto_eliminado.gpc like :search or estatus.descripcion like :search or producto_eliminado.codigo_prod like :search or producto_eliminado.fecha_creacion like :search or producto_elim_detalle.fecha_eliminacion like :search or sub_estatus.descripcion like :search or motivo_retiro.descripcion like :search", search: "%#{params[:sSearch]}%")
    end

    if params[:sSearch_0].present? # Filtro de busqueda Nombre de la Empresa
      productos = productos.where("empresa.nombre_empresa like :search0", search0: "%#{params[:sSearch_0]}%" )
    end
    
    if params[:sSearch_1].present? # Filtro de busqueda por Tipo GTIN
      productos = productos.where("tipo_gtin.tipo like :search1", search1: "%#{params[:sSearch_1]}%" )
    end

    if params[:sSearch_2].present? # Filtro GTIN
      productos = productos.where("producto_eliminado.gtin like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    
    if params[:sSearch_3].present?
      productos = productos.where("producto_eliminado.descripcion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_4].present?
      productos = productos.where("producto_eliminado.marca like :search4", search4: "%#{params[:sSearch_4]}%" )
    end


    if params[:sSearch_6].present?
      productos = productos.where("producto_eliminado.codigo_prod like :search6", search6: "%#{params[:sSearch_6]}%" )
    end

    if params[:sSearch_7].present?
      productos = productos.where("producto_eliminado.fecha_creacion like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    if params[:sSearch_8].present?
      productos = productos.where("producto_elim_detalle.fecha_eliminacion like :search8", search8: "%#{params[:sSearch_8]}%" )
    end
    
    if params[:sSearch_9].present?
      productos = productos.where("sub_estatus.descripcion like :search9", search9: "%#{params[:sSearch_9]}%" )
    end

    if params[:sSearch_10].present?
      productos = productos.where("motivo_retiro.descripcion like :search10", search10: "%#{params[:sSearch_10]}%" )
    end
    
    productos
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