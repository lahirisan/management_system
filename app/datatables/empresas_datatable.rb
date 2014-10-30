#encoding: UTF-8
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
      fecha =  empresa.fecha_activacion.strftime("%Y-%m-%d") if (empresa.fecha_activacion)
      
      empresa.solv

      

      if UsuariosAlcance.verificar_alcance(session[:perfil], 'Modificar Empresa')
        
        ## Se verifica la solvencia, no solvente no puede codificar
        if empresa.solv == 2

          [ 
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha,
          empresa.ciudad_,
          empresa.rif,
          empresa.estatus_,
          "SOLVENTE",
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe, edit_empresa_path(empresa.prefijo, :editar => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, empresa_productos_path(empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios", :class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios de la empresa #{empresa.nombre_empresa}"),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"}),  
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Etiqueta').html_safe, empresa_etiqueta_path(empresa.prefijo, empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Carta_afiliación').html_safe, "/empresas/#{empresa.prefijo}.pdf", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"})
          ]

        else
          [
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha_activacion,
          empresa.ciudad_,
          empresa.rif,
          empresa.estatus_,
          "DEUDOR",
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Editar').html_safe, edit_empresa_path(empresa.prefijo, :editar => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe, empresa_productos_path(empresa.prefijo, :insolvente => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios?insolvente=true", :class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios de la empresa #{empresa.nombre_empresa}"),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa.prefijo, :insolvente => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"}),  
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Etiqueta').html_safe, empresa_etiqueta_path(empresa.prefijo, empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Carta_afiliación').html_safe, "/empresas/#{empresa.prefijo}.pdf", {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"})
          ]

        end

      else
        # Se verifica la solvencia, si esta insolvente no se puede codificar
        if solvencia == 2
        
          [ 
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha_activacion,
          empresa.ciudad_,
          empresa.rif,
          empresa.estatus_,
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe,empresa_productos_path(empresa), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios", :class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios de la empresa #{empresa.nombre_empresa}"),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"}),  
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Etiqueta').html_safe,empresa_etiqueta_path(empresa.prefijo, empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"})
          ]
        else
          [ 
          empresa.prefijo,
          empresa.nombre_empresa,
          fecha_activacion,
          empresa.ciudad_,
          empresa.rif,
          empresa.estatus_,
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Productos').html_safe,empresa_productos_path(empresa, :insolvente => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Productos de la empresa #{empresa.nombre_empresa}"}),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Servicios').html_safe, "/empresas/#{empresa.prefijo}/empresa_servicios?insolvente=true", :class => "ui-state-default ui-corner-all botones_servicio", :title => "Servicios de la empresa #{empresa.nombre_empresa}"),
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'GLN').html_safe, empresa_glns_path(empresa, :insolvente => "true"), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "GLN asociados a la empresa #{empresa.nombre_empresa}"}),  
          link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+'Etiqueta').html_safe,empresa_etiqueta_path(empresa.prefijo, empresa.prefijo), {:class => "ui-state-default ui-corner-all botones_servicio", :title => "Etiqueta de la empresa #{empresa.nombre_empresa}"})
          ]

        end

      end
    
    end

  end

  def empresas
    empresas ||= fetch_empresas

    
  end

  def fetch_empresas
   
    #empresas = Empresa.where("estatus.descripcion = ?", 'Activa').includes(:ciudad, :estatus, :sub_estatus).order("#{sort_column} #{sort_direction}") 
    
    empresas = Empresa.where("estatus.descripcion = ?", 'Activa').joins("inner join ciudad on empresa.id_ciudad = ciudad.id inner join estatus on empresa.id_estatus = estatus.id LEFT OUTER JOIN [BDGS1DTS.MDF].dbo.fnc_CltSlv () ON empresa.prefijo = [BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo").order("#{sort_column} #{sort_direction}").select("empresa.prefijo as prefijo, empresa.nombre_empresa as nombre_empresa, empresa.fecha_activacion as fecha_activacion, ciudad.nombre as ciudad_, empresa.rif as rif, estatus.descripcion as estatus_, isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2)  AS solv")
    

 #   SELECT
 #  prefijo,
 #  isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2)  AS solv
 # FROM
 #  empresa
 # LEFT OUTER JOIN [BDGS1DTS.MDF].dbo.fnc_CltSlv () ON prefijo = [BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo;




    empresas = empresas.page(page).per_page(per_page)








    
    if params[:sSearch].present? # Filtro de busqueda general
      empresas = empresas.where("empresa.prefijo like :search or  empresa.nombre_empresa like :search or empresa.fecha_activacion like :search or  ciudad.nombre like :search or empresa.rif like :search or sub_estatus.descripcion like :search ", search: "%#{params[:sSearch]}%")
    end
    if params[:sSearch_0].present? # Filtro de busqueda prefijo
      empresas = empresas.where("empresa.prefijo like :search0", search0: "%#{params[:sSearch_0]}%" )
    end
    if params[:sSearch_1].present? # Filtro de busqueda por nombre de la empresa
      empresas = empresas.where("empresa.nombre_empresa like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    if params[:sSearch_2].present? # Filtro fecha_activacion
      empresas = empresas.where("empresa.fecha_activacion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end
   
    if params[:sSearch_3].present?
      empresas = empresas.where("ciudad.nombre like :search3", search3: "%#{params[:sSearch_3]}%" )
    end
    if params[:sSearch_4].present?
      empresas = empresas.where("empresa.rif like :search4", search4: "%#{params[:sSearch_4]}%" )
    end

    if params[:sSearch_6].present?
      
      if params[:sSearch_6].upcase == "D" or params[:sSearch_6].upcase == "DE" or params[:sSearch_6].upcase == "DEU" or params[:sSearch_6].upcase == "DEUD" or params[:sSearch_6].upcase == "DEUDO" or params[:sSearch_6].upcase == "DEUDOR"
        
        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) = 2")
        #empresas = empresas.where("sub_estatus.descripcion like :search6", search6: "%#{params[:sSearch_6]}%" )
      elsif params[:sSearch_6].upcase == "S" or params[:sSearch_6].upcase == "SO" or params[:sSearch_6].upcase == "SOL" or params[:sSearch_6].upcase == "SOLV" or params[:sSearch_6].upcase == "SOLVE" or params[:sSearch_6].upcase == "SOLVE" or params[:sSearch_6].upcase == "SOLVEN" or params[:sSearch_6].upcase == "SOLVENT" or params[:sSearch_6].upcase == "SOLVENTE" 

        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) != 2")

      else
        
        empresas = empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) like '#{params[:sSearch_6]}'")
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

     columns = %w[empresa.prefijo empresa.nombre_empresa empresa.fecha_activacion ciudad.nombre empresa.rif estatus.descripcion sub_estatus.descripcion]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  
end
