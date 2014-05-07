class EmpresasEliminadasDatatable < AjaxDatatablesRails
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
      fecha_eliminacion = ""
      fecha =  empresa.fecha_inscripcion.strftime("%Y-%m-%d") if (empresa.fecha_inscripcion)
      fecha_eliminacion = empresa.try(:empresa_elim_detalle).try(:fecha_eliminacion) 
      fecha_eliminacion = (fecha_eliminacion) ? fecha_eliminacion.strftime("%Y-%m-%d") : ""

        [ 
        check_box_tag("reactivar_empresas[]", "#{empresa.id}", false, :class=>"reactivar_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        fecha,
        empresa.ciudad.nombre,
        empresa.rif,
        fecha_eliminacion,
        empresa.sub_estatus.try(:descripcion),
        empresa.motivo_retiro.try(:descripcion),
        link_to("Ver Detalle", empresa_path(empresa, :eliminados => true)),
        link_to("Productos", empresa_productos_path(empresa, :eliminados => true)),
        link_to("Servicios", "/empresas/#{empresa.prefijo}/empresa_servicios?eliminados=true"),
        link_to("GLN", empresa_glns_path(empresa, :eliminados => true))
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
   
    empresas = EmpresaEliminada.includes(:estado, :ciudad, :estatus, :clasificacion, :empresa_elim_detalle).order("#{sort_column} #{sort_direction}")
    
    empresas = empresas.page(page).per_page(per_page)
   
    empresas = empresas.where("empresa_eliminada.nombre_empresa like :search or empresa_eliminada.fecha_inscripcion like :search or ciudad.nombre like :search or empresa_eliminada.rif like :search ", search: "%#{params[:sSearch]}%")  if params[:sSearch].present? # Filtro de busqueda general
  
    empresas = empresas.where("empresa_eliminada.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" )   if params[:sSearch_1].present? # Filtro de busqueda por nombre de la empresa
    empresas = empresas.where("empresa_eliminada.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )  if params[:sSearch_2].present? # Filtro fecha_inscripcion
    empresas = empresas.where("empresa_eliminada.fecha_inscripcion like :search3", search3: "%#{params[:sSearch_3]}%" )  if params[:sSearch_3].present? # Filtro fecha_inscripcion
    empresas = empresas.where("empresa_eliminada.direccion_empresa like :search4", search4: "%#{params[:sSearch_4]}%" ) if params[:sSearch_4].present? # Filtro fecha_inscripcion
    empresas = empresas.where("estados.nombre like :search5", search5: "%#{params[:sSearch_5]}%" ) if params[:sSearch_5].present?
    empresas = empresas.where("ciudad.nombre like :search6", search6: "%#{params[:sSearch_6]}%" ) if params[:sSearch_6].present?
    empresas = empresas.where("empresa_eliminada.rif like :search7", search7: "%#{params[:sSearch_7]}%" ) if params[:sSearch_7].present?
    empresas = empresas.where("empresa_elim_detalle.fecha_eliminacion like :search8", search8: "%#{params[:sSearch_8]}%" ) if params[:sSearch_8].present?
    
    
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