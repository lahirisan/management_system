#encoding: UTF-8
class EmpresaRegistradasActivarSolvenciaDatatable 
  delegate :params, :h, :link_to, :content_tag, :check_box_tag,  to: :@view

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
        check_box_tag("activar_solvencias[]", "#{empresa.id}", false, :class => "activar_solvencia"),
        empresa.rif_completo,
        empresa.nombre_empresa,
        (empresa.fecha_inscripcion) ?  empresa.fecha_inscripcion.strftime("%Y-%m-%d") : "",
        empresa.try(:ciudad).try(:nombre),
        empresa.try(:sub_estatus).try(:descripcion),
        empresa.ventas_brutas_anuales,
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe, "/empresa_registradas/#{empresa.id}/edit", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar la empresa #{empresa.nombre_empresa}"}),
        
      ]
    
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
   
    empresas = EmpresaRegistrada.where("rif IS NOT NULL and sub_estatus.descripcion = 'NO SOLVENTE'").includes(:ciudad, :sub_estatus, :estatus).order("#{sort_column} #{sort_direction}") 
    empresas = empresas.page(page).per_page(per_page)
    
     if params[:sSearch].present? # Filtro de busqueda general
       empresas = empresas.where("empresas_registradas.nombre_empresa like :search  or  ciudad.nombre like :search or empresas_registradas.rif_completo like :search or sub_estatus.descripcion like :search or empresas_registradas.ventas_brutas_anuales like :search", search: "%#{params[:sSearch]}%")
     end
   
     if params[:sSearch_2].present? # Filtro de busqueda por nombre de la empresa
        empresas = empresas.where("empresas_registradas.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )
     end
    
   
     if params[:sSearch_4].present?
       empresas = empresas.where("ciudad.nombre like :search4", search4: "%#{params[:sSearch_4]}%" )
     end
     
     if params[:sSearch_3].present?
      
        empresas = empresas.where("CONVERT(DATETIME, FLOOR(CONVERT(FLOAT, empresas_registradas.fecha_inscripcion))) = '#{params[:sSearch_3]}'")
      
     end

     if params[:sSearch_1].present?
       empresas = empresas.where("empresas_registradas.rif_completo like :search1", search1: "%#{params[:sSearch_1]}%" )
     end

     if params[:sSearch_5].present?
       empresas = empresas.where("sub_estatus.descripcion like :search5", search5: "%#{params[:sSearch_5]}%" )
     end

     if params[:sSearch_6].present?
       empresas = empresas.where("empresas_registradas.ventas_brutas_anuales like :search6", search6: "%#{params[:sSearch_6]}%" )
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

     columns = %w[nil empresas_registradas.rif empresas_registradas.nombre_empresa empresas_registradas.fecha_inscripcion ciudad.nombre sub_estatus.descripcion empresas_registradas.ventas_brutas_anuales]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end
  
end
