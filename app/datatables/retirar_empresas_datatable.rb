class RetirarEmpresasDatatable < AjaxDatatablesRails
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
      fecha =  empresa.fecha_activacion.strftime("%Y-%m-%d") if (empresa.fecha_activacion)

      if empresa.solv == 2
        [ 
          check_box_tag("retirar_empresas[]", "#{empresa.id}", false, :class=>"retirar_empresa"),
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha,
          empresa.ciudad_,
          empresa.rif,
          empresa.estatus_.upcase,
          "SOLVENTE",
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa, :retirar => true), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, "/empresas/#{empresa.prefijo}/productos", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos asociados a la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe,  "/empresas/#{empresa.prefijo}/empresa_servicios",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios asociados a la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, "/empresas/#{empresa.prefijo}/glns",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociado a la empresa #{empresa.nombre_empresa}"}),
          select_tag("motivo_retiro", options_from_collection_for_select(MotivoRetiro.all, "id", "descripcion"), :id => "#{empresa.prefijo}motivo_ret")
        ]

      else

        [ 
          check_box_tag("retirar_empresas[]", "#{empresa.id}", false, :class=>"retirar_empresa"),
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha,
          empresa.ciudad_,
          empresa.rif,
          empresa.estatus_.upcase,
          "DEUDOR",
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa, :retirar => true), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, "/empresas/#{empresa.prefijo}/productos", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos asociados a la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe,  "/empresas/#{empresa.prefijo}/empresa_servicios",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios asociados a la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, "/empresas/#{empresa.prefijo}/glns",  {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociado a la empresa #{empresa.nombre_empresa}"}),
          select_tag("motivo_retiro", options_from_collection_for_select(MotivoRetiro.all, "id", "descripcion"), :id => "#{empresa.prefijo}motivo_ret")
        ]
      end
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
    empresas = Empresa.where("estatus.descripcion = ?", 'Activa').joins("inner join ciudad on empresa.id_ciudad = ciudad.id inner join estatus on empresa.id_estatus = estatus.id LEFT OUTER JOIN [BDGS1DTS.MDF].dbo.fnc_CltSlv () ON empresa.prefijo = [BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo").order("#{sort_column} #{sort_direction}").select("empresa.prefijo as prefijo, empresa.nombre_empresa as nombre_empresa, empresa.fecha_activacion as fecha_activacion, ciudad.nombre as ciudad_, empresa.rif as rif, estatus.descripcion as estatus_, isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2)  AS solv, empresa.fecha_inscripcion as fecha_inscripcion").order("#{sort_column} #{sort_direction}") 
    #empresas = Empresa.includes(:estado, :ciudad, :estatus).where("estatus.descripcion like ? and alcance like ?", 'Activa', 'Empresa')
     
    empresas = empresas.page(page).per_page(per_page)
    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.prefijo like :search or empresa.nombre_empresa like :search or empresa.fecha_activacion like :search or empresa.ciudad_ like :search or empresa.rif like :search or empresa.estatus_ like :search", search: "%#{params[:sSearch]}%")
    end
    
    if params[:sSearch_1].present? # Filtro de busqueda por prefijo
       empresas = empresas.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" )
      
    end
    if params[:sSearch_2].present? # Filtro nombre empresa
      empresas = empresas.where("empresa.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    if params[:sSearch_3].present?
      empresas = empresas.where("CONVERT(varchar(255),  empresa.fecha_activacion ,126) like :search3", search3: "%#{params[:sSearch_3]}%")
      
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

     if params[:sSearch_7].present?
      
      if params[:sSearch_7].upcase == "D" or params[:sSearch_7].upcase == "DE" or params[:sSearch_7].upcase == "DEU" or params[:sSearch_7].upcase == "DEUD" or params[:sSearch_7].upcase == "DEUDO" or params[:sSearch_7].upcase == "DEUDOR"
        
        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) != 2")

        
      elsif params[:sSearch_7].upcase == "S" or params[:sSearch_7].upcase == "SO" or params[:sSearch_7].upcase == "SOL" or params[:sSearch_7].upcase == "SOLV" or params[:sSearch_7].upcase == "SOLVE" or params[:sSearch_7].upcase == "SOLVE" or params[:sSearch_7].upcase == "SOLVEN" or params[:sSearch_7].upcase == "SOLVENT" or params[:sSearch_7].upcase == "SOLVENTE" 

        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) = 2")

      else
        
        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) like '#{params[:sSearch_7]}'")
      end 
    
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

     columns = %w[empresa.prefijo empresa.nombre_empresa empresa.fecha_activacion ciudad.nombre empresa.rif  estatus.descripcion ]
     columns[params[:iSortCol_0].to_i]
     
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  
end