class RetirarProductosDatatable < AjaxDatatablesRails
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
        check_box_tag("retirar_productos[]", "#{producto.gtin}", false, :class=>"retirar_producto"),
        producto.try(:productos_empresa).try(:empresa).try(:nombre_empresa),
        producto.try(:tipo_gtin).try(:tipo),
        producto.gtin,
        producto.descripcion,
        producto.marca,
        producto.try(:estatus).try(:descripcion),
        producto.codigo_prod,
        fecha,
        select_tag("sub_estatus", options_from_collection_for_select(SubEstatus.all, "id", "descripcion", producto.productos_retirados.try(:id_subestatus)), :id => "#{producto.gtin}sub_estatus"),
        select_tag("motivo_retiro", options_from_collection_for_select(MotivoRetiro.all, "id", "descripcion", producto.productos_retirados.try(:id_motivo_retiro)), :id => "#{producto.gtin}motivo_ret")
       
      ]
      
      

    end

  end

  def productos
    productos ||= fetch_productos
  end

  def fetch_productos
     productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion = ?", params[:empresa_id], 'Activo').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin).order("producto.fecha_creacion") 
    #productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion like ? and estatus.alcance like ?",params[:empresa_id], 'Activo', 'Producto').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin, {:productos_retirados => :sub_estatus}, {:productos_retirados => :motivo_retiro})
    productos = productos.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      productos = productos.where("empresa.nombre_empresa like :search or tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or producto.gpc like :search or estatus.descripcion like :search or estatus.descripcion like :search or producto.codigo_prod like :search ", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_1].present? # Filtro de busqueda Nombre de la Empresa
      productos = productos.where("empresa.nombre_empresa like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    
    if params[:sSearch_2].present? # Filtro de busqueda por Tipo GTIN
      productos = productos.where("tipo_gtin.tipo like :search2", search2: "%#{params[:sSearch_2]}%" )
    end

    if params[:sSearch_3].present? # Filtro GTIN
      productos = productos.where("producto.gtin like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    
    if params[:sSearch_4].present?
      productos = productos.where("producto.descripcion like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_5].present?
      productos = productos.where("producto.marca like :search5", search5: "%#{params[:sSearch_5]}%" )
    end

    if params[:sSearch_7].present?
      productos = productos.where("producto.codigo_prod like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    if params[:sSearch_8].present?
      productos = productos.where("producto.fecha_creacion like :search8", search8: "%#{params[:sSearch_8]}%" )
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