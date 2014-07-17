class ProductosDatatable < AjaxDatatablesRails
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
      
      
      if (producto.id_tipo_gtin == 1) or (producto.id_tipo_gtin == 3)
        base = (producto.id_tipo_gtin == 1) ? 4 : 6  # Para mostrar seleccioando la base del producto cunado se crear GTIN 14

        [ 
          producto.try(:productos_empresa).try(:empresa).try(:nombre_empresa),
          producto.try(:tipo_gtin).try(:tipo),
          producto.gtin,
          producto.descripcion,
          producto.marca,
          producto.try(:estatus).try(:descripcion),
          producto.codigo_prod,
          fecha,
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe,"/empresas/#{params[:empresa_id]}/productos/#{producto.gtin}/edit",{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar producto"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+"GTIN14").html_safe, "/empresas/#{params[:empresa_id]}/productos/new?gtin=#{producto.gtin}&base=#{base}&descripcion=#{producto.descripcion}&marca=#{producto.marca}&gpc=#{producto.gpc}",{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Generar GTIN-14"})
        ]

      else

        [ 
          producto.try(:productos_empresa).try(:empresa).try(:nombre_empresa),
          producto.try(:tipo_gtin).try(:tipo),
          producto.gtin,
          producto.descripcion,
          producto.marca,
          producto.try(:estatus).try(:descripcion),
          producto.codigo_prod,
          fecha,
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe,"/empresas/#{params[:empresa_id]}/productos/#{producto.gtin}/edit", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar producto"}),
          ""
        ]

      end
      
    end

  end

  def productos
    productos ||= fetch_productos
  end

  def fetch_productos
    
    productos = Producto.where("productos_empresa.prefijo = ? and estatus.descripcion = ?", params[:empresa_id], 'Activo').includes({:productos_empresa => :empresa}, :estatus, :tipo_gtin).order("#{sort_column} #{sort_direction}") 
    productos = productos.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      productos = productos.where("tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or producto.gpc like :search or estatus.descripcion like :search or estatus.descripcion like :search or producto.codigo_prod like :search ", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_0].present? # Filtro de busqueda Nombre de la Empresa
      productos = productos.where("empresa.nombre_empresa like :search0", search0: "%#{params[:sSearch_0]}%" )
    end
    
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