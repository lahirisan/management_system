class EmpresasRetiradasDatatable < AjaxDatatablesRails
  delegate :params, :h,  :link_to, :check_box_tag, :try, :select_tag, :options_from_collection_for_select,  to: :@view

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
      
      fecha = ""
      fecha =  empresa.fecha_inscripcion.strftime("%Y-%m-%d") if (empresa.fecha_inscripcion)
      sub_estatus = empresa.empresas_retiradas.try(:sub_estatus).try(:descripcion).nil? ? 'No Tiene' : empresa.empresas_retiradas.try(:sub_estatus).try(:descripcion)
      motivo_retiro = empresa.empresas_retiradas.try(:motivo_retiro).try(:descripcion).nil? ? 'No Tiene' : empresa.empresas_retiradas.try(:motivo_retiro).try(:descripcion)
      fecha_retiro = empresa.empresas_retiradas.try(:fecha_retiro).nil? ? '' : empresa.empresas_retiradas.fecha_retiro.strftime("%Y-%m-%d")

        [ 
        empresa.prefijo,
        empresa.nombre_empresa,
        fecha,
        empresa.ciudad.nombre,
        empresa.rif,
        fecha_retiro,
        empresa.empresas_retiradas.try(:motivo_retiro).try(:descripcion),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa, :retirar => true), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, empresa_productos_path(empresa, :retirados => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios?retirados=true", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa, :retirados => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"})
        
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
    
    empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, {:empresas_retiradas => :sub_estatus},{:empresas_retiradas => :motivo_retiro}).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa')
    empresas = empresas.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.prefijo like :search  or empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or ciudad.nombre like :search or empresa.rif like :search", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_0].present? # Filtro de busqueda por prefijo
       empresas = empresas.where("empresa.prefijo like :search0", search0: "%#{params[:sSearch_0]}%" )
      
    end
    if params[:sSearch_1].present? # Filtro nombre empresa
      empresas = empresas.where("empresa.nombre_empresa like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    if params[:sSearch_2].present?
      empresas = empresas.where("empresa.fecha_inscripcion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    if params[:sSearch_3].present?
      empresas = empresas.where("ciudad.nombre like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    if params[:sSearch_4].present?
      empresas = empresas.where("empresa.rif like :search4", search4: "%#{params[:sSearch_4]}%" )
    end
    if params[:sSearch_5].present?
       empresas = empresas.where("empresas_retiradas.fecha_retiro like :search5", search5: "%#{params[:sSearch_5]}%" )
    end
   
   
   
    empresas
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.prefijo empresa.nombre_empresa empresa.fecha_inscripcion  ciudad.nombre empresa.rif empresas_retiradas.fecha_retiro motivo_retiro.descripcion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  
end