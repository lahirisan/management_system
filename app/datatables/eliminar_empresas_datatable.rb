class EliminarEmpresasDatatable < AjaxDatatablesRails
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
        [ 
        check_box_tag("eliminar_empresas[]", "#{empresa.id}", false, :class => "eliminar_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        fecha,
        empresa.ciudad.nombre,
        empresa.rif,
        empresa.empresas_retiradas.fecha_retiro.strftime("%Y-%m-%d"),
        select_tag("sub_estatus", options_from_collection_for_select(SubEstatus.all, "id", "descripcion", empresa.empresas_retiradas.try(:id_subestatus)), :id => "#{empresa.prefijo}sub_estatus"),
        select_tag("motivo_retiro", options_from_collection_for_select(MotivoRetiro.all, "id", "descripcion", empresa.empresas_retiradas.try(:id_motivo_retiro)), :id => "#{empresa.prefijo}motivo_ret"),
        link_to("Ver Detalle", empresa_path(empresa, :retirar => true)),
        link_to("Productos", empresa_productos_path(empresa, :retirados => "true")),
        link_to("Servicios", "/empresas/#{empresa.prefijo}/empresa_servicios"),
        link_to("GLN", empresa_glns_path(empresa))
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
    empresas = Empresa.includes(:estado, :ciudad, :estatus, :clasificacion, {:empresas_retiradas => :sub_estatus},{:empresas_retiradas => :motivo_retiro}).where("estatus.descripcion like ? and alcance like ?", 'Retirada', 'Empresa').order("#{sort_column} #{sort_direction}")
    empresas = empresas.page(page).per_page(per_page)
    
    empresas = empresas.where("empresa.nombre_empresa like :search or empresa.fecha_inscripcion like :search or ciudad.nombre like :search or empresa.rif like :search", search: "%#{params[:sSearch]}%") if params[:sSearch].present? # Filtro de busqueda general
    
    empresas = empresas.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" ) if params[:sSearch_1].present? 
    empresas = empresas.where("empresa.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )   if params[:sSearch_2].present? # Filtro nombre empresa
    empresas = empresas.where("empresa.fecha_inscripcion like :search3", search3: "%#{params[:sSearch_3]}%" ) if params[:sSearch_3].present?
    empresas = empresas.where("ciudad.nombre like :search4", search4: "%#{params[:sSearch_4]}%" ) if params[:sSearch_4].present?
    empresas = empresas.where("empresa.rif like :search5", search5: "%#{params[:sSearch_5]}%" ) if params[:sSearch_5].present?
    empresas = empresas.where("empresas_retiradas.fecha_retiro like :search6", search6: "%#{params[:sSearch_6]}%" ) if params[:sSearch_6].present?
    empresas = empresas.where("sub_estatus.descripcion like :search7", search7: "%#{params[:sSearch_7]}%" ) if params[:sSearch_7].present?
    empresas = empresas.where("motivo_retiro.descripcion like :search8", search8: "%#{params[:sSearch_8]}%" ) if params[:sSearch_8].present?
    
    empresas

  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[empresa.prefijo empresa.nombre_empresa empresa.fecha_inscripcion  ciudad.nombre empresa.rif empresas_retiradas.fecha_retiro sub_estatus.descripcion motivo_retiro.descripcion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

end