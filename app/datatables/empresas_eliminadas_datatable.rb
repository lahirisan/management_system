class EmpresasEliminadasDatatable
  delegate :params, :h,  :link_to, :check_box_tag,  to: :@view

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
        empresa.prefijo,
        empresa.nombre_empresa,
        empresa.rif,
        empresa.categoria,
        empresa.division,
        empresa.grupo,
        empresa.clase,
        empresa.try(:tipo_usuario_empresa).try(:descripcion),
        empresa.try(:estatus).try(:descripcion),
        empresa.rep_legal,
        empresa.contacto_tlf1,
        empresa.contacto_email1,
        empresa.motivo_retiro.try(:descripcion),
        (empresa.fecha_retiro) ? empresa.fecha_retiro.strftime("%Y-%m-%d") : "",
        (empresa.fecha_eliminacion) ? empresa.fecha_eliminacion.strftime("%Y-%m-%d") : ""
        
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
   
    empresas = EmpresaEliminada.includes(:estatus, :motivo_retiro, :tipo_usuario_empresa)
    empresas = empresas.page(page).per_page(per_page)
   
    empresas = empresas.where("empresa_eliminada.prefijo like :search or empresa_eliminada.nombre_empresa like :search or  empresa_eliminada.rif like :search ", search: "%#{params[:sSearch]}%")  if params[:sSearch].present? # Filtro de busqueda general
  
    # empresas = empresas.where("empresa_eliminada.prefijo like :search0", search0: "%#{params[:sSearch_0]}%" )   if params[:sSearch_0].present? # Filtro de busqueda por nombre de la empresa
    # empresas = empresas.where("empresa_eliminada.nombre_empresa like :search1", search1: "%#{params[:sSearch_1]}%" )  if params[:sSearch_1].present? # Filtro fecha_inscripcion
    # empresas = empresas.where("empresa_eliminada.fecha_inscripcion like :search2", search2: "%#{params[:sSearch_2]}%" )  if params[:sSearch_2].present? # Filtro fecha_inscripcion
    # empresas = empresas.where("ciudad.nombre like :search3", search3: "%#{params[:sSearch_3]}%" ) if params[:sSearch_3].present?
    # empresas = empresas.where("empresa_eliminada.rif like :search4", search4: "%#{params[:sSearch_4]}%" ) if params[:sSearch_4].present?
    # empresas = empresas.where("empresa_elim_detalle.fecha_eliminacion like :search5", search5: "%#{params[:sSearch_5]}%" ) if params[:sSearch_5].present?
    
    
    
    empresas
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa_eliminada.prefijo empresa_eliminada.nombre_empresa empresa_eliminada.fecha_inscripcion ciudad.nombre empresa_eliminada.rif empresa_elim_detalle.fecha_eliminacion ]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end