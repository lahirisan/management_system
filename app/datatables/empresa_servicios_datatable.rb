class EmpresaServiciosDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

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
      if UsuariosAlcance.verificar_alcance(session[:perfil], 'Modificar Servicio') or (params[:empresa_retirada] == 'false')
        [
          empresa_servicio.empresa.nombre_empresa,
          empresa_servicio.servicio.nombre,
          empresa_servicio.fecha_contratacion.strftime("%Y-%m-%d"),
          empresa_servicio.fecha_finalizacion.strftime("%Y-%m-%d"),
          empresa_servicio.nombre_contacto,
          empresa_servicio.cargo_contacto,
          empresa_servicio.telefono,
          empresa_servicio.email,
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe,"/empresas/#{params[:empresa_id]}/empresa_servicios/#{empresa_servicio.id}/edit",{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar servicio"})
        ]
      else
        [
          empresa_servicio.empresa.nombre_empresa,
          empresa_servicio.servicio.nombre,
          empresa_servicio.fecha_contratacion.strftime("%Y-%m-%d"),
          empresa_servicio.fecha_finalizacion.strftime("%Y-%m-%d"),
          empresa_servicio.nombre_contacto,
          empresa_servicio.cargo_contacto,
          empresa_servicio.telefono,
          empresa_servicio.email
          
        ]

      end

      
    end

  end

  def empresa_servicios
    empresa_servicios ||= fetch_empresa_servicios
  end

  def fetch_empresa_servicios

    
    empresa_servicios = EmpresaServicio.where("empresa_servicios.prefijo = ?", params[:empresa_id]).includes(:servicio, :empresa).order("#{sort_column} #{sort_direction}") 
    empresa_servicios = empresa_servicios.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresa_servicios = empresa_servicios.where("servicios.nombre like :search  or empresa_servicios.fecha_contratacion like :search or empresa_servicios.fecha_finalizacion like :search or empresa_servicios.nombre_contacto like :search or empresa_servicios.cargo_contacto like :search or empresa_servicios.telefono like :search or empresa_servicios.email like :search", search: "%#{params[:sSearch]}%")
    end
    

    if params[:sSearch_1].present? # Filtro de busqueda por Tipo GTIN
      empresa_servicios = empresa_servicios.where("servicios.nombre like :search1", search1: "%#{params[:sSearch_1]}%" )
    end

    if params[:sSearch_2].present? # Filtro GTIN
      empresa_servicios = empresa_servicios.where("empresa_servicios.fecha_contratacion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    
    if params[:sSearch_3].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.fecha_finalizacion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_4].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.nombre_contacto like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_5].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.cargo_contacto like :search5", search5: "%#{params[:sSearch_5]}%" )
    end

    if params[:sSearch_6].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.telefono like :search6", search6: "%#{params[:sSearch_6]}%" )
    end

    if params[:sSearch_7].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios.email like :search7", search7: "%#{params[:sSearch_7]}%" )
    end

    empresa_servicios
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.nombre_empresa servicios.nombre empresa_servicios.fecha_contratacion empresa_servicios.fecha_finalizacion empresa_servicios.nombre_contacto empresa_servicios.cargo_contacto empresa_servicios.telefono empresa_servicios.email]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end