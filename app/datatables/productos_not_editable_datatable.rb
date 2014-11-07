class ProductosNotEditableDatatable < AjaxDatatablesRails
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
          
          producto.try(:tipo_gtin).try(:tipo),
          producto.gtin,
          producto.descripcion,
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
    
    productos = Producto.where("prefijo = ?", params[:empresa_id]).includes(:estatus, :tipo_gtin).order("#{sort_column} #{sort_direction}") 
    productos = productos.page(page).per_page(per_page)
    
     if params[:sSearch].present? # Filtro de busqueda general
      productos = productos.where("tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or estatus.descripcion like :search or estatus.descripcion like :search or producto.codigo_prod like :search or producto.fecha_creacion like :search", search: "%#{params[:sSearch]}%")
    end
    
    
    if params[:sSearch_0].present? # Filtro de busqueda por Tipo GTIN
      productos = productos.where("tipo_gtin.tipo like :search0", search0: "%#{params[:sSearch_0]}%" )
    end

    if params[:sSearch_1].present? # Filtro GTIN
      productos = productos.where("producto.gtin like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    
    if params[:sSearch_2].present?
      productos = productos.where("producto.descripcion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end

    if params[:sSearch_3].present?
      productos = productos.where("producto.marca like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_5].present?
      productos = productos.where("producto.codigo_prod like :search5", search5: "%#{params[:sSearch_5]}%" )
    end

    if params[:sSearch_6].present?
      
      productos = productos.where("CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search6", search6: "%#{params[:sSearch_6]}%")
      
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

     columns = %w[empresa.nombre_empresa tipo_gtin.tipo producto.gtin producto.descripcion producto.marca producto.gpc estatus.descripcion producto.codigo_prod producto.fecha_creacion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end