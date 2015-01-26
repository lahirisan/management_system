class GlnsDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

   def initialize(view)
    @view = view
   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: glns.count,
      iTotalDisplayRecords: glns.total_entries,      
      aaData: data
    }

  end

private

  def data


    glns.map do |empresa_gln|
          
        if params[:empresa_retirada] == 'true'
          estatus = "Retirado"
          boton_detalle = (link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, "/empresas/#{params[:empresa_id]}/glns/#{empresa_gln.gln}?retirado=true",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de  GLN #{empresa_gln.try(:gln)}"}))
          
        else
          estatus = empresa_gln.try(:estatus).try(:descripcion)
          boton_detalle = (link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, "/empresas/#{params[:empresa_id]}/glns/#{empresa_gln.gln}",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de  GLN #{empresa_gln.try(:gln)}"}))
        end

          if (empresa_gln.try(:tipo_gln).try(:nombre) == 'Legal') or UsuariosAlcance.verificar_alcance(session[:perfil], session[:gerencia], 'Modificar GLN').nil? # GLN legal no se edita , sino tiewne el priviligeo no se edita GLN
            [ 
            empresa_gln.try(:gln),
            empresa_gln.try(:tipo_gln).try(:nombre),
            empresa_gln.try(:codigo_localizacion),
            empresa_gln.try(:descripcion),
            estatus,
            empresa_gln.try(:fecha_asignacion),
            empresa_gln.try(:estado),
            empresa_gln.try(:municipio),
            empresa_gln.try(:ciudad),
            "",
            boton_detalle
            ]
          else
            
            [ 
            empresa_gln.try(:gln),
            empresa_gln.try(:tipo_gln).try(:nombre),
            empresa_gln.try(:codigo_localizacion),
            empresa_gln.try(:descripcion),
            estatus,
            empresa_gln.try(:fecha_asignacion),
            empresa_gln.try(:estado),
            empresa_gln.try(:municipio),
            empresa_gln.try(:ciudad),
            link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe,"/empresas/#{params[:empresa_id]}/glns/#{empresa_gln.gln}/edit",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar datos GLN #{empresa_gln.try(:gln)}"}),
            boton_detalle
            ]
          end
          
       

    end

  end

  def glns
    glns ||= fetch_glns
  end

  def fetch_glns

    
    glns = Gln.where("gln.prefijo = ?", params[:empresa_id]).includes(:tipo_gln ,  :estatus, :empresa).order("#{sort_column} #{sort_direction}") 

    
    
    glns = glns.page(page).per_page(per_page)

    
    if params[:sSearch].present? # Filtro de busqueda general
      glns = glns.where("gln like :search or tipo_gln.nombre like :search or gln.codigo_localizacion like :search or gln.descripcion like :search or estatus.descripcion like :search or gln.fecha_asignacion like :search or estados.nombre like :search or municipio.nombre like :search or ciudad.nombre like :search ", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_0].present? # Filtro de busqueda Nombre de la Empresa
      glns = glns.where("gln like :search0", search0: "%#{params[:sSearch_0]}%" )
    end
    
    if params[:sSearch_1].present? # Filtro de busqueda por Tipo GTIN
      glns = glns.where("tipo_gln.nombre like :search1", search1: "%#{params[:sSearch_1]}%" )
    end

    if params[:sSearch_2].present? # Filtro GTIN
      glns = glns.where("codigo_localizacion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    
    if params[:sSearch_3].present?
      glns = glns.where("descripcion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_4].present?
      glns = glns.where("estatus.descripcion like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_5].present?
      glns = glns.where("fecha_asignacion like :search5", search5: "%#{params[:sSearch_5]}%" )
    end

    if params[:sSearch_6].present?
      glns = glns.where("estados.nombre like :search6", search6: "%#{params[:sSearch_6]}%")
    end

    if params[:sSearch_7].present?
      glns = glns.where("municipio.nombre like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    if params[:sSearch_8].present?
      glns = glns.where("ciudad.nombre like :search8", search8: "%#{params[:sSearch_8]}%" )
    end



    glns
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    prueba =params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[gln.gln tipo_gln.nombre gln.codigo_localizacion gln.descripcion estatus.descripcion gln.fecha_asignacion estados.nombre municipio.nombre ciudad.nombre]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end