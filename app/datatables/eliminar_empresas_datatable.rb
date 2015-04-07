class EliminarEmpresasDatatable 
  delegate :params, :h,  :link_to, :check_box_tag, :content_tag, :empresa_path, :empresa_productos_path, :empresa_glns_path,   to: :@view

   def initialize(view)
    @view = view

   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: empresas.count,
      iTotalDisplayRecords: empresas.total_entries,      
      aaData: data
    }

  end

private

  def data

    empresas.map do |empresa|
      
        [ 
        check_box_tag("eliminar_empresas[]", "#{empresa.id}", false, :class => "eliminar_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        (empresa.fecha_inscripcion) ? empresa.fecha_inscripcion.strftime("%Y-%m-%d") : "",
        empresa.ciudad.nombre,
        empresa.rif,
        (empresa.fecha_retiro) ? empresa.fecha_retiro.strftime("%Y-%m-%d") : "",
        empresa.try(:motivo_retiro).try(:descripcion),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa, :retirar => true),{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, empresa_productos_path(empresa, :empresa_retirada => "true"),{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios",{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe,empresa_glns_path(empresa, :empresa_retirada => "true"),{:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"})
        
        
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
    empresas = Empresa.includes(:estado, :ciudad, :estatus, :motivo_retiro).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("#{sort_column} #{sort_direction}") 
    empresas = empresas.page(page).per_page(per_page)
    
    empresas = empresas.where("empresa.prefijo like :search or empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or ciudad.nombre like :search or empresa.rif like :search", search: "%#{params[:sSearch]}%") if params[:sSearch].present? # Filtro de busqueda general
    empresas = empresas.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" ) if params[:sSearch_1].present? 
    empresas = empresas.where("empresa.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )   if params[:sSearch_2].present? # Filtro nombre empresa
    empresas = empresas.where("empresa.fecha_inscripcion like :search3", search3: "%#{params[:sSearch_3]}%" ) if params[:sSearch_3].present?
    empresas = empresas.where("ciudad.nombre like :search4", search4: "%#{params[:sSearch_4]}%" ) if params[:sSearch_4].present?
    empresas = empresas.where("empresa.rif like :search5", search5: "%#{params[:sSearch_5]}%" ) if params[:sSearch_5].present?
    empresas = empresas.where("empresa.fecha_retiro like :search6", search6: "%#{params[:sSearch_6]}%" ) if params[:sSearch_6].present?
    
    empresas = empresas.where("motivo_retiro.descripcion like :search12", search12: "%#{params[:sSearch_12]}%" ) if params[:sSearch_12].present?
    
    empresas

  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.prefijo empresa.nombre_empresa empresa.fecha_inscripcion  ciudad.nombre empresa.rif empresa.fecha_retiro sub_estatus.descripcion motivo_retiro.descripcion]
     columns[params[:iSortCol_0].to_i]

  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

end