class EmpresaServiciosEliminadosDatatable < AjaxDatatablesRails
  delegate :params, :h, :link_to,  to: :@view

   def initialize(view)
    @view = view
   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: empresa_servicios_eliminados.count,
      iTotalDisplayRecords: empresa_servicios_eliminados.total_entries,      
      aaData: data
    }

  end

private

  def data

    empresa_servicios_eliminados.map do |empresa_servicio_eliminado|

        empresa = empresa_servicio_eliminado.try(:empresa).try(:nombre_empresa) ? empresa_servicio_eliminado.try(:empresa).try(:nombre_empresa) : empresa_servicio_eliminado.try(:empresa_eliminada).try(:nombre_empresa)

        [
          empresa,
          empresa_servicio_eliminado.servicio.nombre,
          empresa_servicio_eliminado.fecha_contratacion.strftime("%Y-%m-%d"),
          empresa_servicio_eliminado.fecha_finalizacion.strftime("%Y-%m-%d"),
          empresa_servicio_eliminado.nombre_contacto,
          empresa_servicio_eliminado.cargo_contacto,
          empresa_servicio_eliminado.telefono,
          empresa_servicio_eliminado.email,
          empresa_servicio_eliminado.try(:sub_estatus).try(:descripcion),
          empresa_servicio_eliminado.try(:motivo_retiro).try(:descripcion),
          empresa_servicio_eliminado.fecha_eliminacion.strftime("%Y-%m-%d")
        ]
      
    end

  end

  def empresa_servicios_eliminados
    empresa_servicios ||= fetch_empresa_servicios_eliminados
  end

  def fetch_empresa_servicios_eliminados

    empresa_servicios = EmpresaServiciosEliminado.where("prefijo = ?", params[:empresa_id]).includes(:servicio, :sub_estatus, :motivo_retiro).order("#{sort_column} #{sort_direction}") 
    empresa_servicios = empresa_servicios.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda generalx
      empresa_servicios = empresa_servicios.where("servicios.nombre like :search or empresa_servicios_eliminado.fecha_contratacion like :search or empresa_servicios_eliminado.fecha_finalizacion like :search or empresa_servicios_eliminado.nombre_contacto like :search or empresa_servicios_eliminado.cargo_contacto like :search or empresa_servicios_eliminado.telefono like :search or empresa_servicios_eliminado.email like :search or  sub_estatus.descripcion like :search or motivo_retiro.descripcion like :search or empresa_servicios_eliminado.fecha_eliminacion like :search", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_1].present? # Filtro GTIN
      empresa_servicios = empresa_servicios.where("servicios.nombre like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    
    if params[:sSearch_2].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios_eliminado.fecha_contratacion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end

    if params[:sSearch_3].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios_eliminado.fecha_finalizacion like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_4].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios_eliminado.nombre_contacto like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_5].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios_eliminado.cargo_contacto like :search5", search5: "%#{params[:sSearch_5]}%")
    end

    if params[:sSearch_6].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios_eliminado.telefono like :search6", search6: "%#{params[:sSearch_6]}%" )
    end

    if params[:sSearch_7].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios_eliminado.email like :search7", search7: "%#{params[:sSearch_7]}%" )
    end
    
    if params[:sSearch_8].present?
      empresa_servicios = empresa_servicios.where("sub_estatus.descripcion like :search8", search8: "%#{params[:sSearch_8]}%" )
    end

    if params[:sSearch_9].present?
      empresa_servicios = empresa_servicios.where("motivo_retiro.descripcion like :search9", search9: "%#{params[:sSearch_9]}%" )
    end

    if params[:sSearch_10].present?
      empresa_servicios = empresa_servicios.where("empresa_servicios_eliminado.fecha_eliminacion like :search10", search10: "%#{params[:sSearch_10]}%" )
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

     columns = %w[servicios.nombre empresa_servicios_eliminado.fecha_contratacion empresa_servicios_eliminado.fecha_finalizacion empresa_servicios_eliminado.nombre_contacto empresa_servicios_eliminado.cargo_contacto empresa_servicios_eliminado.telefono empresa_servicios_eliminado.email sub_estatus.descripcion motivo_retiro.descripcion empresa_servicios_eliminado.fecha_eliminacion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end