 class EliminarProductosDatatable 
  delegate :params, :h, :link_to, :check_box_tag,  to: :@view

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
      
        
        
      [ 
        check_box_tag("eliminar_productos[]", "#{producto.gtin}", false, :class=>"eliminar_producto"),
        producto.try(:tipo_gtin).try(:tipo),
        producto.gtin,
        producto.descripcion,
        producto.marca,
        producto.try(:estatus).try(:nombre),
        producto.codigo_prod,
        (producto.fecha_creacion) ? producto.fecha_creacion.strftime("%Y-%m-%d") : ""
        
      ]

    end

  end

  def productos
    productos ||= fetch_productos
  end

  def fetch_productos

    productos = Producto.where("prefijo = ? and estatus.descripcion = ?", params[:empresa_id], 'Activo').includes(:estatus, :tipo_gtin).order("#{sort_column} #{sort_direction}")
    
    productos = productos.page(page).per_page(per_page)
    
   
    if params[:sSearch_1].present? # Filtro de busqueda por Tipo GTIN
      productos = productos.where("tipo_gtin.tipo like :search1", search1: "%#{params[:sSearch_1]}%" )
    end

    if params[:sSearch_2].present? # Filtro GTIN
      productos = productos.where("producto.gtin like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    
    if params[:sSearch_3].present?
      productos = productos.where("producto.descripcion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_4].present?
      productos = productos.where("producto.marca like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

  
    if params[:sSearch_6].present?
      productos = productos.where("producto.codigo_prod like :search6", search6: "%#{params[:sSearch_6]}%" )
    end

    if params[:sSearch_7].present?
      productos = productos.where("CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search7", search7: "%#{params[:sSearch_7]}%")
      
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

     columns = %w[nil tipo_gtin.tipo producto.gtin producto.descripcion producto.marca estatus.descripcion producto.codigo_prod producto.fecha_creacion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end