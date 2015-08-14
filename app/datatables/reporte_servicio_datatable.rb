class ReporteServicioDatatable 
  
  delegate :params, :h, :link_to, :content_tag,  to: :@view

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
          empresa_servicio.nombre_empresa,
          empresa_servicio.prefijo,
          empresa_servicio.estatus_,
          empresa_servicio.clasificacion_,
          empresa_servicio.servicio_,
          (empresa_servicio.fecha_contratacion) ?  empresa_servicio.fecha_contratacion.strftime("%Y-%m-%d") : "",
          (empresa_servicio.fecha_finalizacion) ?  empresa_servicio.fecha_finalizacion.strftime("%Y-%m-%d") : "",
          empresa_servicio.nombre_contacto,
          empresa_servicio.email,
          empresa_servicio.telefono
          
        ]
      
    end

  end

  def empresa_servicios
    empresa_servicios ||= fetch_empresa_servicios
  end

  def fetch_empresa_servicios

    
    empresa_servicios = EmpresaServicio.joins(:servicio, {:empresa => :estatus}, {:empresa => :clasificacion} ).select("empresa.nombre_empresa as nombre_empresa, empresa.prefijo as prefijo, estatus.descripcion as estatus_, empresa_clasificacion.descripcion as clasificacion_, servicios.nombre as servicio_, empresa_servicios.fecha_contratacion as fecha_contratacion, empresa_servicios.fecha_finalizacion as fecha_finalizacion, empresa_servicios.nombre_contacto as nombre_contacto, empresa_servicios.email as email, empresa_servicios.telefono as telefono").order("#{sort_column} #{sort_direction}") 
    empresa_servicios = empresa_servicios.page(page).per_page(per_page)
    
    empresa_servicios = empresa_servicios.where("empresa.nombre_empresa like like :search or  empresa.prefijo like like :search  or  servicios.nombre like :search  or CONVERT(varchar(255),  empresa_servicios.fecha_contratacion ,126) like  like :search or CONVERT(varchar(255),  empresa_servicios.fecha_finalizacion ,126) like  :search or empresa_servicios.nombre_contacto like :search or empresa_servicios.cargo_contacto like :search or empresa_servicios.telefono like :search or empresa_servicios.email like :search", search: "%#{params[:sSearch]}%")  if params[:sSearch].present? # Filtro de busqueda general
     
    empresa_servicios = empresa_servicios.where("empresa.nombre_empresa like '%#{params[:sSearch_0]}%'") if params[:sSearch_0].present?
    empresa_servicios = empresa_servicios.where("empresa.prefijo like '%#{params[:sSearch_1]}%'") if params[:sSearch_1].present?
    empresa_servicios = empresa_servicios.where("estatus.descripcion like '%#{params[:sSearch_2]}%'") if params[:sSearch_2].present?
    
    empresa_servicios = empresa_servicios.where("empresa_clasificacion.descripcion like '%#{params[:sSearch_3]}%'") if params[:sSearch_3].present?
    empresa_servicios = empresa_servicios.where("servicios.nombre like '%#{params[:sSearch_4]}%'") if params[:sSearch_4].present?
    empresa_servicios = empresa_servicios.where("CONVERT(varchar(255),  empresa_servicios.fecha_contratacion ,126) like '%#{params[:sSearch_5]}%'")  if params[:sSearch_5].present?
    empresa_servicios = empresa_servicios.where("CONVERT(varchar(255),  empresa_servicios.fecha_finalizacion ,126) like  '%#{params[:sSearch_6]}%'" )  if params[:sSearch_6].present?
    empresa_servicios = empresa_servicios.where("empresa_servicios.nombre_contacto like '%#{params[:sSearch_7]}%'") if params[:sSearch_7].present?
    empresa_servicios = empresa_servicios.where("empresa_servicios.email like '%#{params[:sSearch_8]}%'" ) if params[:sSearch_8].present?
    empresa_servicios = empresa_servicios.where("empresa_servicios.telefono '%#{params[:sSearch_9]}%'") if params[:sSearch_9].present?
    
    empresa_servicios

  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.nombre_empresa empresa.prefijo servicios.nombre empresa_servicios.fecha_contratacion empresa_servicios.fecha_finalizacion empresa_servicios.nombre_contacto empresa_servicios.cargo_contacto empresa_servicios.email empresa_servicios.telefono ]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end