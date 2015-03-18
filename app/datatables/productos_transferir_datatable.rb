#encoding: UTF-8
class ProductosTransferirDatatable < AjaxDatatablesRails
  delegate :params, :h, :check_box_tag,  :link_to,  to: :@view

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
      fecha_modificacion = ""
      fecha_modificacion =  producto.fecha_ultima_modificacion.strftime("%Y-%m-%d") if (producto.fecha_ultima_modificacion)
      
      [ 
       check_box_tag("transferir_gtin8[]", "#{producto.gtin.strip}", false, :class => "transferir_producto_seleccionado"),
       producto.try(:empresa).try(:nombre_empresa),
       producto.empresa.prefijo,
       producto.try(:tipo_gtin).try(:tipo),
       producto.gtin,
       producto.descripcion,
       producto.marca,
       producto.try(:estatus).try(:descripcion),
       producto.codigo_prod,
       fecha,
       fecha_modificacion,
      

      ]
      
    end

  end

  def productos

    productos ||= fetch_productos
  end

  def fetch_productos
    
    productos = Producto.where("id_tipo_gtin = 1").includes(:estatus, :tipo_gtin, :empresa).order("#{sort_column} #{sort_direction}") 
    productos = productos.page(page).per_page(per_page)

    productos = productos.where("empresa.nombre_empresa like :search or  empresa.prefijo  like :search or  tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or estatus.descripcion like :search or  producto.codigo_prod like :search or CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search or CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like :search", search: "%#{params[:sSearch]}%") if params[:sSearch].present? # Filtro de busqueda general
    productos = productos.where("empresa.nombre_empresa like :search1", search1: "%#{params[:sSearch_1]}%" ) if params[:sSearch_1].present? # Filtro de busqueda por nombre empresa
    
    productos = productos.where("empresa.prefijo like :search2", search2: "%#{params[:sSearch_2]}%" ) if params[:sSearch_2].present? # Filtro PREFIJO
      
    productos = productos.where("tipo_gtin.tipo like :search3", search3: "%#{params[:sSearch_3]}%" ) if params[:sSearch_3].present? #tipo_gtin
    
    productos = productos.where("producto.gtin like :search4", search4: "%#{params[:sSearch_4]}%" )  if params[:sSearch_4].present? #GTIN

    productos = productos.where("producto.descripcion like :search5", search5: "%#{params[:sSearch_5]}%" ) if params[:sSearch_5].present?  # descripcion de producto
  
    productos = productos.where("producto.marca like :search6", search6: "%#{params[:sSearch_6]}%" )     if params[:sSearch_6].present? # marca producto
    productos = productos.where("estatus.descripcion like :search7", search7: "%#{params[:sSearch_7]}%" ) if params[:sSearch_7].present? # por estatus producto
    
    productos = productos.where("producto.codigo_prod like :search8", search8: "%#{params[:sSearch_8]}%" )     if params[:sSearch_8].present? # codigo producto
   
    productos = productos.where("CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search9", search9: "%#{params[:sSearch_9]}%")  if params[:sSearch_9].present? # fecha creacion
    productos = productos.where("CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like :search10", search10: "%#{params[:sSearch_10]}%") if params[:sSearch_10].present? # fecha modificacion
    
    productos

  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page


    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[nil empresa.nombre_empresa empresa.prefijo tipo_gtin.tipo producto.gtin producto.descripcion producto.marca estatus.descripcion producto.codigo_prod producto.fecha_creacion producto.fecha_ultima_modificacion]
     columns[params[:iSortCol_0].to_i]

  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end