#encoding: UTF-8
class ProductosGtin8Datatable 
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
     
      
      
      
      [ 
       producto.nombre_empresa,
       producto.prefijo,
       producto.tipo_gtin_,
       producto.gtin,
       producto.descripcion,
       producto.marca,
       producto.estatus_,
       producto.codigo_producto,
       (producto.fecha_creacion) ? producto.fecha_creacion.strftime("%Y-%m-%d") : "",
       (producto.fecha_ultima_modificacion) ?  producto.fecha_ultima_modificacion.strftime("%Y-%m-%d") : ""
      

      ]
      
    end

  end

  def productos

    productos ||= fetch_productos
  end

  def fetch_productos
    
    productos = Producto.where("id_tipo_gtin = 1").joins(:estatus, :tipo_gtin, :empresa).select("empresa.nombre_empresa as nombre_empresa, empresa.prefijo as prefijo, tipo_gtin.tipo as tipo_gtin_, producto.descripcion as descripcion, producto.marca as marca, estatus.descripcion as estatus_, producto.codigo_prod as codigo_producto, producto.fecha_creacion as fecha_creacion, producto.fecha_ultima_modificacion as fecha_ultima_modificacion, producto.gtin as gtin").order("#{sort_column} #{sort_direction}") 
    productos = productos.page(page).per_page(per_page)

    productos = productos.where("empresa.nombre_empresa like :search or  empresa.prefijo  like :search or  tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or estatus.descripcion like :search or  producto.codigo_prod like :search or CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search or CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like :search", search: "%#{params[:sSearch]}%") if params[:sSearch].present? # Filtro de busqueda general
    productos = productos.where("empresa.nombre_empresa like :search0", search0: "%#{params[:sSearch_0]}%" ) if params[:sSearch_0].present? # Filtro de busqueda por nombre empresa
    
    productos = productos.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" ) if params[:sSearch_1].present? # Filtro PREFIJO
      
    productos = productos.where("tipo_gtin.tipo like :search2", search2: "%#{params[:sSearch_2]}%" ) if params[:sSearch_2].present? #tipo_gtin
    
    productos = productos.where("producto.gtin like :search3", search3: "%#{params[:sSearch_3]}%" )  if params[:sSearch_3].present? #GTIN

    productos = productos.where("producto.descripcion like :search4", search4: "%#{params[:sSearch_4]}%" ) if params[:sSearch_4].present?  # descripcion de producto
  
    productos = productos.where("producto.marca like :search5", search5: "%#{params[:sSearch_5]}%" )     if params[:sSearch_5].present? # marca producto
    productos = productos.where("estatus.descripcion like :search6", search6: "%#{params[:sSearch_6]}%" ) if params[:sSearch_6].present? # por estatus producto
    
    productos = productos.where("producto.codigo_prod like :search7", search7: "%#{params[:sSearch_7]}%" )     if params[:sSearch_7].present? # codigo producto
   
    productos = productos.where("CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search8", search8: "%#{params[:sSearch_8]}%")  if params[:sSearch_8].present? # fecha creacion
    productos = productos.where("CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like :search9", search9: "%#{params[:sSearch_9]}%") if params[:sSearch_9].present? # fecha modificacion
    

    productos
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page


    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.nombre_empresa empresa.prefijo tipo_gtin.tipo producto.gtin producto.descripcion producto.marca estatus.descripcion producto.codigo_prod producto.fecha_creacion producto.fecha_ultima_modificacion]
     columns[params[:iSortCol_0].to_i]

  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end