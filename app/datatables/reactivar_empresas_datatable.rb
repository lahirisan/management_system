class ReactivarEmpresasDatatable 
  delegate :params, :h,  :link_to, :check_box_tag, :content_tag, :empresa_path,   to: :@view

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
        check_box_tag("reactivar_empresas[]", "#{empresa.prefijo}", false, :class=>"reactivar_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        empresa.clasificacion_,
        empresa.ciudad_,
        empresa.tipo_usuario_empresa_,
        (empresa.fecha_retiro) ? empresa.fecha_retiro.strftime("%Y-%m-%d") : "",
        empresa.motivo_retiro_,
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa, :retirar => true), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, "/empresas/#{empresa.prefijo}/productos?empresa_retirada=true", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, "/empresas/#{empresa.prefijo}/glns?empresa_retirada=true", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"}),
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Carta_Retiro').html_safe, "/empresas/#{empresa.prefijo}.pdf?retiro_individual=true", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}", :target => "_blank"})
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
    empresas = Empresa.joins("left join [empresa_clasificacion] ON [empresa_clasificacion].[id] = [empresa].[id_clasificacion] left JOIN [ciudad] ON [ciudad].[id] = [empresa].[id_ciudad] left JOIN [motivo_retiro] ON [motivo_retiro].[id] = [empresa].[id_motivo_retiro] left join tipo_usuario_empresa on tipo_usuario_empresa.id_tipo_usu_empresa = empresa.id_tipo_usuario left join estatus on empresa.id_estatus = estatus.id").select("empresa.prefijo, empresa.nombre_empresa, empresa.fecha_activacion, ciudad.nombre as ciudad_,  empresa.fecha_retiro, motivo_retiro.descripcion as motivo_retiro_,  empresa_clasificacion.descripcion as clasificacion_, tipo_usuario_empresa.descripcion as tipo_usuario_empresa_").where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("#{sort_column} #{sort_direction}") 
    empresas = empresas.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.prefijo like :search  or empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or ciudad.nombre like :search or empresa.rif like :search", search: "%#{params[:sSearch]}%")
    end
    
    empresas = empresas.where("empresa.prefijo like :search or empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or ciudad.nombre like :search or empresa.rif like :search", search: "%#{params[:sSearch]}%") if params[:sSearch].present? # Filtro de busqueda general
    empresas = empresas.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" ) if params[:sSearch_1].present? 
    empresas = empresas.where("empresa.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )   if params[:sSearch_2].present? # Filtro nombre empresa
    empresas = empresas.where("empresa_clasificacion.descripcion like :search3", search3: "%#{params[:sSearch_3]}%" ) if params[:sSearch_3].present?
    empresas = empresas.where("ciudad.nombre like :search4", search4: "%#{params[:sSearch_4]}%" ) if params[:sSearch_4].present?
    empresas = empresas.where("tipo_usuario_empresa.descripcion like :search5", search5: "%#{params[:sSearch_5]}%" ) if params[:sSearch_5].present?
    empresas = empresas.where("empresa.fecha_retiro like :search6", search6: "%#{params[:sSearch_6]}%" ) if params[:sSearch_6].present?
    empresas = empresas.where("motivo_retiro.descripcion like :search7", search7: "%#{params[:sSearch_7]}%" ) if params[:sSearch_7].present?
    
    empresas

  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[nil empresa.prefijo empresa.nombre_empresa empresa_clasificacion.descripcion ciudad.nombre tipo_usuario_empresa.descripcion empresa.fecha_retiro motivo_retiro.descripcion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  
end