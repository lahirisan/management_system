class EmpresasTransferirGtinDatatable < AjaxDatatablesRails
  delegate :params, :h,  :link_to, :check_box_tag, :try, :select_tag,  to: :@view

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
      
      estatus_administrativo = (empresa.solv == 2) ? "SOLVENTE" : "DEUDOR" # SE VERIFICA EL ESTATUS ADMINISTRATIVO DE LA EMPRESA

      [ 
        check_box_tag("empresa_transferir_gtin[]", "#{empresa.prefijo}", false, :class => "transferir_gtin_a_empresa"),
        empresa.prefijo,
        empresa.nombre_empresa,
        empresa.rif_completo,
        empresa.estatus_.upcase,
        estatus_administrativo,
        link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Detalle').html_safe, empresa_path(empresa, :retirar => true),{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Detalle de la empresa #{empresa.nombre_empresa}"})
      ]
  
    end

  end

  def empresas
    empresas ||= fetch_empresas
  end

  def fetch_empresas
    
    empresas = Empresa.where("estatus.descripcion = ?", 'Activa').joins("inner join estatus on empresa.id_estatus = estatus.id LEFT OUTER JOIN [BDGS1DTS.MDF].dbo.fnc_CltSlv () ON empresa.prefijo = [BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo").select("empresa.prefijo as prefijo, empresa.nombre_empresa as nombre_empresa, empresa.rif_completo as rif_completo, estatus.descripcion as estatus_, isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2)  AS solv").order("#{sort_column} #{sort_direction}")
    empresas = empresas.page(page).per_page(per_page)

    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.prefijo like :search or  empresa.nombre_empresa like :search or empresa.rif_completo like :search", search: "%#{params[:sSearch]}%")
    end
    if params[:sSearch_1].present? # Filtro de busqueda prefijo
      empresas = empresas.where("empresa.prefijo like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    if params[:sSearch_2].present? # Filtro de busqueda por nombre de la empresa
      empresas = empresas.where("empresa.nombre_empresa like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
    if params[:sSearch_3].present?
      empresas = empresas.where("empresa.rif_completo like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    # if params[:sSearch_4].present?
    #   empresas = empresas.where("estatus.descripcion like :search4", search4: "%#{params[:sSearch_4]}%" )
    # end

    if params[:sSearch_5].present?
      
      if params[:sSearch_5].upcase == "D" or params[:sSearch_5].upcase == "DE" or params[:sSearch_5].upcase == "DEU" or params[:sSearch_5].upcase == "DEUD" or params[:sSearch_5].upcase == "DEUDO" or params[:sSearch_5].upcase == "DEUDOR"
        
        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) != 2")

        
      elsif params[:sSearch_5].upcase == "S" or params[:sSearch_5].upcase == "SO" or params[:sSearch_5].upcase == "SOL" or params[:sSearch_5].upcase == "SOLV" or params[:sSearch_5].upcase == "SOLVE" or params[:sSearch_5].upcase == "SOLVE" or params[:sSearch_5].upcase == "SOLVEN" or params[:sSearch_5].upcase == "SOLVENT" or params[:sSearch_5].upcase == "SOLVENTE" 

        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) = 2")

      else
        
        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) like '#{params[:sSearch_5]}'")
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

     columns = %w[null empresa.prefijo empresa.nombre_empresa empresa.rif_completo estatus.descripcion empresa.solv]
     columns[params[:iSortCol_0].to_i]

  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

end