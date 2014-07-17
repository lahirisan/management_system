class EmpresasDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

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

      if UsuariosAlcance.verificar_alcance(session[:perfil], 'Modificar Empresa')
        [ 
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha,
          empresa.estado.nombre,
          empresa.ciudad.nombre,
          empresa.rif,
          empresa.estatus.descripcion,
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa),  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),        
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe, edit_empresa_path(empresa, :editar => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, empresa_productos_path(empresa), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios", :class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios de la empresa #{empresa.nombre_empresa}"),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"}),  
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Etiqueta').html_safe, empresa_etiqueta_path(empresa.prefijo, empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"})
        ]

      else

        [ 
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha,
          empresa.estado.nombre,
          empresa.ciudad.nombre,
          empresa.rif,
          empresa.estatus.descripcion,
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa),  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),        
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe,empresa_productos_path(empresa), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios", :class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios de la empresa #{empresa.nombre_empresa}"),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"}),  
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Etiqueta').html_safe,empresa_etiqueta_path(empresa.prefijo, empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"})
        ]

      end
    
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
   
    empresas = Empresa.where("estatus.descripcion = ?", 'Activa').includes(:estado, :ciudad, :estatus).order("#{sort_column} #{sort_direction}") 
    empresas = empresas.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.prefijo like :search or  empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or estados.nombre like :search or ciudad.nombre like :search or empresa.rif like :search or estatus.descripcion like :search", search: "%#{params[:sSearch]}%")
    end
    if params[:sSearch_0].present? # Filtro de busqueda prefijo
      empresas = empresas.where("empresa.prefijo like :search0", search0: "%#{params[:sSearch_0]}%" )
    end
    if params[:sSearch_1].present? # Filtro de busqueda por nombre de la empresa
      empresas = empresas.where("empresa.nombre_empresa like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    if params[:sSearch_2].present? # Filtro fecha_inscripcion
      empresas = empresas.where("empresa.fecha_inscripcion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    if params[:sSearch_3].present?
      empresas = empresas.where("estados.nombre like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    if params[:sSearch_4].present?
      empresas = empresas.where("ciudad.nombre like :search4", search4: "%#{params[:sSearch_4]}%" )
    end
    if params[:sSearch_5].present?
      empresas = empresas.where("empresa.rif like :search5", search5: "%#{params[:sSearch_5]}%" )
    end
    if params[:sSearch_6].present?
      empresas = empresas.where("estatus.descripcion like :search6", search6: "%#{params[:sSearch_6]}%" )
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

     columns = %w[empresa.prefijo empresa.nombre_empresa empresa.fecha_inscripcion estados.nombre ciudad.nombre empresa.rif  estatus.descripcion ]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  
end